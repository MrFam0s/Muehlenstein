// SPDX-License-Identifier: AGPL-3.0-or-later
import XCTest
import UIKit
@testable import Muehlenstein

final class GameStoreTests: XCTestCase {
    @MainActor private func waitForHuman(_ store: GameStore, timeout: Duration = .seconds(6)) async throws {
        let deadline = ContinuousClock.now.advanced(by: timeout)
        while store.isThinking || !store.isHumanTurn {
            if ContinuousClock.now > deadline { XCTFail("Computer turn did not finish"); return }
            try await Task.sleep(for: .milliseconds(20))
        }
        XCTAssertNil(store.errorMessage)
    }
    @MainActor func testComputerMoveHasVisibleMinimumTimeAndLocksInput() async throws {
        let store = GameStore(inMemory: true, pacing: ComputerPacing(fixedDelay: .milliseconds(650)))
        store.start(GameSettings(level: 1))
        let began = ContinuousClock.now
        store.tap(23) // a7
        XCTAssertTrue(store.isThinking)
        store.tap(22) // Ignore touch during computer's turn.
        try await Task.sleep(for: .milliseconds(180))
        XCTAssertEqual(store.game?.moves.count, 1)
        XCTAssertEqual(store.activity, .computer)
        try await waitForHuman(store)
        XCTAssertGreaterThanOrEqual(began.duration(to: ContinuousClock.now), .milliseconds(650))
        XCTAssertEqual(store.game?.moves.count, 2)
        XCTAssertEqual(store.position?.lastTurn.count, 1)
        XCTAssertEqual(store.game?.moves.last?.side, 1)
    }
    @MainActor func testNewGameDiscardsPendingComputerMove() async throws {
        let store = GameStore(inMemory: true, pacing: ComputerPacing(fixedDelay: .milliseconds(500)))
        store.start(GameSettings(level: 5))
        store.tap(23)
        store.start(GameSettings(variant: .lasker, opponent: .local))
        try await Task.sleep(for: .milliseconds(900))
        XCTAssertEqual(store.game?.settings.variant, .lasker)
        XCTAssertEqual(store.game?.moves.count, 0)
        XCTAssertFalse(store.isThinking)
        XCTAssertNil(store.errorMessage)
    }
    @MainActor func testSuspendAndResumeApplyExactlyOneComputerMove() async throws {
        let store = GameStore(inMemory: true, pacing: ComputerPacing(fixedDelay: .milliseconds(350)))
        store.start(GameSettings(level: 1))
        store.tap(23)
        try await Task.sleep(for: .milliseconds(80))
        store.suspend()
        try await Task.sleep(for: .milliseconds(450))
        XCTAssertEqual(store.game?.moves.count, 1)
        XCTAssertFalse(store.isThinking)
        store.resumeComputer()
        store.resumeComputer() // Repeated scene notifications must not duplicate the search.
        try await waitForHuman(store)
        XCTAssertEqual(store.game?.moves.count, 2)
    }
    @MainActor func testComputerMillAndCaptureRemainSeparateAndUndoTogether() async throws {
        let file = URL.temporaryDirectory.appending(path: UUID().uuidString + ".json")
        defer { try? FileManager.default.removeItem(at: file) }
        // Black's only immediate mill is e5; a separate action must then remove a white stone.
        let records = ["a7", "c5", "d7", "d5", "g1"].enumerated().map { MoveRecord(notation: $0.element, side: $0.offset % 2) }
        let saved = SavedGame(settings: GameSettings(level: 1), moves: records)
        try JSONEncoder().encode(saved).write(to: file)
        let store = GameStore(storageURL: file, pacing: ComputerPacing(fixedDelay: .milliseconds(450)))
        store.resumeComputer()
        let deadline = ContinuousClock.now.advanced(by: .seconds(5))
        while store.game?.moves.count == 5 && ContinuousClock.now < deadline {
            try await Task.sleep(for: .milliseconds(10))
        }
        XCTAssertEqual(store.game?.moves.count, 6)
        XCTAssertEqual(store.position?.action, 2)
        XCTAssertTrue(store.isThinking)
        let millShown = ContinuousClock.now
        try await Task.sleep(for: .milliseconds(150))
        XCTAssertEqual(store.game?.moves.count, 6)
        try await waitForHuman(store)
        XCTAssertGreaterThanOrEqual(millShown.duration(to: ContinuousClock.now), .milliseconds(350))
        XCTAssertEqual(store.game?.moves.count, 7)
        XCTAssertEqual(store.position?.lastTurn.count, 2)
        store.undo()
        XCTAssertEqual(store.game?.moves.count, 4)
        XCTAssertEqual(store.position?.side, 0)
    }
    @MainActor func testInvalidSaveIsPreservedAndNotAccepted() throws {
        let file = URL.temporaryDirectory.appending(path: UUID().uuidString + ".json")
        defer { try? FileManager.default.removeItem(at: file) }
        let corrupt = Data("not valid JSON".utf8)
        try corrupt.write(to: file)
        let store = GameStore(storageURL: file)
        XCTAssertNil(store.game)
        XCTAssertNotNil(store.errorMessage)
        XCTAssertEqual(try Data(contentsOf: file), corrupt)
    }
    @MainActor func testRestoredComputerTurnCompletesAndPersists() async throws {
        let file = URL.temporaryDirectory.appending(path: UUID().uuidString + ".json")
        defer { try? FileManager.default.removeItem(at: file) }
        let saved = SavedGame(settings: GameSettings(level: 1), moves: [MoveRecord(notation: "a7", side: 0)])
        try JSONEncoder().encode(saved).write(to: file)
        let store = GameStore(storageURL: file, pacing: ComputerPacing(fixedDelay: .milliseconds(50)))
        store.resumeComputer()
        try await waitForHuman(store)
        let restored = GameStore(storageURL: file)
        XCTAssertEqual(restored.game?.moves, store.game?.moves)
        XCTAssertEqual(restored.position?.board, store.position?.board)
        XCTAssertEqual(restored.position?.lastTurn, store.position?.lastTurn)
    }
    func testNativeCancellationIsScoped() throws {
        let cancelled = try SearchCancellation()
        let live = try SearchCancellation()
        cancelled.cancel()
        let game = SavedGame(settings: GameSettings(level: 1))
        XCTAssertThrowsError(try Engine.query(game, search: true, cancellation: cancelled)) { error in
            XCTAssertTrue(error is CancellationError)
        }
        XCTAssertNotNil(try Engine.query(game, search: true, cancellation: live).best)
    }
    @MainActor func testTextPaginationPreservesWholeLicenseAndUnicode() throws {
        let url = try XCTUnwrap(Bundle.main.url(forResource: "AGPL-3.0", withExtension: "txt"))
        let text = try String(contentsOf: url, encoding: .utf8) + "\nMühlenstein · Weiß → Schwarz 👨‍👩‍👧‍👦 e\u{301}\n"
        for fontSize: CGFloat in [17, 53] {
            let pages = TextPagination.pages(text, size: CGSize(width: 280, height: 300), font: .systemFont(ofSize: fontSize))
            XCTAssertGreaterThan(pages.count, 1)
            XCTAssertEqual(pages.joined(), text, "Pagination must neither omit nor duplicate characters")
            XCTAssertFalse(pages.contains(where: \.isEmpty))
        }
    }

    @MainActor func testDisplayPreferencesPersistIndependentlyOfGame() throws {
        let suite = "MuehlensteinTests.\(UUID().uuidString)"
        let defaults = try XCTUnwrap(UserDefaults(suiteName: suite))
        defer { defaults.removePersistentDomain(forName: suite) }
        let preferences = AppPreferences(defaults: defaults)
        XCTAssertTrue(preferences.showLegalMoves)
        XCTAssertTrue(preferences.showLastMove)
        XCTAssertTrue(preferences.showLevel)
        preferences.showLegalMoves = false
        preferences.showLastMove = false
        preferences.showLevel = false
        let restored = AppPreferences(defaults: defaults)
        XCTAssertFalse(restored.showLegalMoves)
        XCTAssertFalse(restored.showLastMove)
        XCTAssertFalse(restored.showLevel)
    }

    func testFiveLevelSettingsRoundtripThroughSaveAndEngine() throws {
        for level in GameSettings.levels {
            let settings = GameSettings(variant: .morabaraba, level: level, algorithm: .pvs, effort: .extended)
            let saved = SavedGame(settings: settings, moves: [MoveRecord(notation: "a7", side: 0)])
            let restored = try JSONDecoder().decode(SavedGame.self, from: JSONEncoder().encode(saved))
            XCTAssertEqual(restored.settings, settings)
            XCTAssertEqual(try Engine.query(restored).actors, [0])
        }
        for level in [0, 6] {
            XCTAssertThrowsError(try Engine.query(SavedGame(settings: GameSettings(level: level))))
        }
    }

    @MainActor func testChangingComputerSettingsRestartsPendingSearchAndPreservesGame() async throws {
        let file = URL.temporaryDirectory.appending(path: UUID().uuidString + ".json")
        defer { try? FileManager.default.removeItem(at: file) }
        let store = GameStore(storageURL: file, pacing: ComputerPacing(fixedDelay: .milliseconds(500)))
        store.start(GameSettings(level: 5))
        store.tap(23)
        XCTAssertTrue(store.isThinking)
        // Only computer configuration may change; variant and opponent must be preserved.
        store.updateComputerSettings(GameSettings(variant: .lasker, opponent: .local, level: 1, algorithm: .pvs, effort: .extended))
        XCTAssertEqual(store.game?.moves, [MoveRecord(notation: "a7", side: 0)])
        XCTAssertEqual(store.game?.settings.variant, .classic)
        XCTAssertEqual(store.game?.settings.opponent, .computer)
        XCTAssertTrue(store.isThinking)
        try await waitForHuman(store)
        try await Task.sleep(for: .milliseconds(600))
        XCTAssertEqual(store.game?.moves.count, 2, "The superseded search must not apply an extra move")
        let restored = GameStore(storageURL: file)
        XCTAssertEqual(restored.game?.settings.algorithm, .pvs)
        XCTAssertEqual(restored.game?.settings.effort, .extended)
        XCTAssertEqual(restored.game?.moves, store.game?.moves)
    }

}
