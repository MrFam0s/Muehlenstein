// SPDX-License-Identifier: AGPL-3.0-or-later
import XCTest
import UIKit
@testable import Muehlenstein

final class GameStoreTests: XCTestCase {
    @MainActor func testReplayIncludesHintsUndoAndAbandonedCaptureWithoutChangingSave() throws {
        let file = URL.temporaryDirectory.appending(path: UUID().uuidString + ".json")
        defer { try? FileManager.default.removeItem(at: file) }
        let store = GameStore(storageURL: file)
        store.start(GameSettings(opponent: .local))
        for notation in ["c5", "a7", "d5", "d7", "e5", "xa7"] {
            store.play(try XCTUnwrap(store.position?.legal.first { $0.notation == notation }))
        }
        let abandoned = try XCTUnwrap(store.position).fen
        store.undo()
        let beforeCapture = try XCTUnwrap(store.position).fen
        store.play(try XCTUnwrap(store.position?.legal.first { $0.notation == "xd7" }))
        var snapshot = try XCTUnwrap(store.game)
        let savedBytes = try Data(contentsOf: file)
        let originalMoves = snapshot.moves
        XCTAssertEqual(try snapshot.replay(at: 6).position.fen, abandoned)
        XCTAssertEqual(try snapshot.replay(at: 6).highlight?.kind, 2)
        XCTAssertEqual(try snapshot.replay(at: 7).position.fen, beforeCapture)
        XCTAssertEqual(try snapshot.replay(at: 8).position.fen, store.position?.fen)
        XCTAssertEqual(try snapshot.replay(at: 0).moves.count, 0)
        let hint = try XCTUnwrap(store.position?.legal.first)
        snapshot.record(GameHistoryEntry(kind: .hint, moveNumber: snapshot.moves.count, side: store.position!.side, notation: hint.notation))
        let hinted = try snapshot.replay(at: 9)
        XCTAssertEqual(hinted.highlight, hint)
        XCTAssertEqual(hinted.position.fen, store.position?.fen)
        XCTAssertEqual(hinted.moves, originalMoves)
        XCTAssertEqual(try Data(contentsOf: file), savedBytes)
        XCTAssertEqual(store.game?.undoCount, 1)
        XCTAssertEqual(store.game?.hintCount, 0)
        XCTAssertThrowsError(try snapshot.replay(at: -1))
        XCTAssertThrowsError(try snapshot.replay(at: 10))
        // A published save has only canonical moves; it is still reviewable.
        snapshot.history = nil
        XCTAssertEqual(try snapshot.replay(at: originalMoves.count).position.fen, store.position?.fen)
    }

    @MainActor func testAssistanceJournalSurvivesUndoBranchesAndRelaunch() async throws {
        let file = URL.temporaryDirectory.appending(path: UUID().uuidString + ".json")
        defer { try? FileManager.default.removeItem(at: file) }
        let store = GameStore(storageURL: file)
        store.start(GameSettings(opponent: .local, level: 4))
        store.toggleHint()
        store.toggleHint() // Cancel before the result is displayed.
        try await Task.sleep(for: .milliseconds(50))
        XCTAssertEqual(store.game?.hintCount, 0)
        store.toggleHint()
        try await waitForHuman(store)
        XCTAssertEqual(store.game?.hintCount, 1)
        store.toggleHint() // Hiding a displayed hint is not another use.
        XCTAssertEqual(store.game?.hintCount, 1)
        store.play(try XCTUnwrap(store.position?.legal.first))
        store.undo()
        XCTAssertEqual(store.game?.historyEntries.map(\.kind), [.hint, .move, .undo])
        XCTAssertEqual(store.game?.undoCount, 1)
        XCTAssertTrue(store.game?.activeHistoryMoves.isEmpty == true)
        store.toggleHint()
        try await waitForHuman(store)
        store.suspend()
        let restored = GameStore(storageURL: file)
        XCTAssertEqual(restored.game?.hintCount, 2)
        XCTAssertEqual(restored.game?.undoCount, 1)
        XCTAssertEqual(restored.game?.historyEntries, store.game?.historyEntries)
        XCTAssertTrue(restored.game?.moves.isEmpty == true)
        restored.play(try XCTUnwrap(restored.position?.legal.first))
        XCTAssertEqual(restored.game?.activeHistoryMoves, [4])
        restored.play(try XCTUnwrap(restored.position?.legal.first))
        restored.undo()
        XCTAssertEqual(restored.game?.activeHistoryMoves, [4])
        restored.undo()
        restored.undo() // An unavailable undo is not logged.
        XCTAssertEqual(restored.game?.undoCount, 3)
        XCTAssertEqual(restored.game?.hintCount, 2)
        XCTAssertEqual(restored.game?.history?.includesWholeGame, true)
        restored.start(GameSettings(opponent: .local))
        XCTAssertEqual(restored.game?.hintCount, 0)
        XCTAssertEqual(restored.game?.undoCount, 0)
        XCTAssertTrue(restored.game?.historyEntries.isEmpty == true)
    }

    @MainActor func testPublishedSaveWithoutJournalRetainsUnknownPastAssistance() throws {
        let file = URL.temporaryDirectory.appending(path: UUID().uuidString + ".json")
        defer { try? FileManager.default.removeItem(at: file) }
        let old = SavedGame(settings: GameSettings(opponent: .local), moves: [MoveRecord(notation: "a7", side: 0)])
        try JSONEncoder().encode(old).write(to: file)
        let store = GameStore(storageURL: file)
        XCTAssertNil(store.errorMessage)
        XCTAssertNil(store.game?.history)
        XCTAssertEqual(store.game?.historyEntries.count, 1)
        store.undo()
        XCTAssertEqual(store.game?.historyEntries.map(\.kind), [.move, .undo])
        XCTAssertEqual(store.game?.history?.includesWholeGame, false)
        XCTAssertEqual(GameStore(storageURL: file).game?.undoCount, 1)
    }

    @MainActor func testNetworkDuplicateProposalAndLateAcknowledgementCannotAdvanceTwice() throws {
        let link = MatchTestLink()
        let host = LocalMatchSession(transport: link.white), guest = LocalMatchSession(transport: link.black)
        host.host(variant: .classic); guest.browse()
        guest.join(NearbyGame(id: "test", matchID: try XCTUnwrap(host.identity).id, variant: .classic))
        link.connect(); link.pump(); host.acceptInvitation(); link.pump()
        host.play(try XCTUnwrap(host.position?.legal.first))
        link.pump()
        let before = try XCTUnwrap(guest.game), identity = try XCTUnwrap(guest.identity), position = try XCTUnwrap(guest.position)
        let snapshot = LocalMatchSnapshot(id: identity.id, resumeKey: identity.resumeKey, variant: .classic, moves: before.moves, fen: position.fen)
        let action = try XCTUnwrap(position.legal.first)
        let proposal = LocalMatchPacket(event: .move(revision: before.moves.count, digest: snapshot.digest, action: action))
        guest.play(action)
        XCTAssertEqual(guest.game?.moves, before.moves, "A proposal is not a committed move")
        link.pump()
        let after = host.game?.moves
        link.white.onData?(try proposal.encoded())
        XCTAssertFalse(host.canPlay, "Resending a snapshot requires its acknowledgement")
        link.white.onData?(try LocalMatchPacket(event: .acknowledged(revision: before.moves.count, digest: snapshot.digest)).encoded())
        XCTAssertFalse(host.canPlay, "Old acknowledgements cannot unlock the current snapshot")
        link.pump()
        XCTAssertTrue(host.canPlay)
        XCTAssertEqual(host.game?.moves, after)
        XCTAssertEqual(guest.game?.moves, after)
        XCTAssertEqual(host.game?.moves.count, 2)
        let rollback = LocalMatchSnapshot(id: identity.id, resumeKey: identity.resumeKey, variant: .classic,
                                         moves: before.moves, fen: snapshot.fen)
        XCTAssertThrowsError(try rollback.validatedGame(previous: guest.game))
        host.stop(); guest.stop()
    }

    func testNetworkPrivacyPermissionIsBundledInEveryLanguage() throws {
        XCTAssertEqual(Bundle.main.object(forInfoDictionaryKey: "NSBonjourServices") as? [String], ["_muehlenstein._tcp"])
        for language in ["de", "en", "es", "fr", "ja", "ko", "zh-Hans", "zh-Hant"] {
            let directory = try XCTUnwrap(Bundle.main.path(forResource: language, ofType: "lproj"))
            let file = URL(fileURLWithPath: directory).appending(path: "InfoPlist.strings")
            let strings = try XCTUnwrap(PropertyListSerialization.propertyList(from: Data(contentsOf: file), format: nil) as? [String: String])
            XCTAssertFalse(try XCTUnwrap(strings["NSLocalNetworkUsageDescription"]).isEmpty, language)
        }
    }


    @MainActor func testNetworkInvitationMustBeAcceptedBeforeSharingGame() throws {
        let link = MatchTestLink()
        let host = LocalMatchSession(transport: link.white)
        let guest = LocalMatchSession(transport: link.black)
        host.host(variant: .classic)
        guest.browse()
        guest.join(NearbyGame(id: "test", matchID: try XCTUnwrap(host.identity).id, variant: .classic))
        link.connect()
        link.pump()
        XCTAssertEqual(host.phase, .awaitingApproval)
        XCTAssertEqual(guest.phase, .awaitingApproval)
        XCTAssertNil(guest.game, "No transcript or resume key is shared before approval")
        XCTAssertFalse(host.canPlay)
        XCTAssertFalse(guest.hasStarted)
        host.acceptInvitation()
        let approvedHost = GameStore(inMemory: true)
        approvedHost.adoptNetwork(host)
        XCTAssertNotNil(approvedHost.game?.network, "Host approval must establish the resumable match before the first acknowledgement")
        XCTAssertFalse(approvedHost.isHumanTurn)
        link.pump()
        XCTAssertTrue(host.hasStarted)
        XCTAssertTrue(guest.hasStarted)
        XCTAssertTrue(host.canPlay)
        XCTAssertFalse(guest.canPlay)
        XCTAssertEqual(host.position?.fen, guest.position?.fen)
        XCTAssertEqual(guest.identity?.side, 1)
        host.stop(); guest.stop()
    }

    @MainActor func testNetworkAllArchivedGamesStayIdenticalIncludingCapturesAndGameOver() throws {
        let url = try XCTUnwrap(Bundle(for: Self.self).url(forResource: "offline-games", withExtension: "json"))
        let fixtures = try JSONDecoder().decode(OfflineFixtures.self, from: Data(contentsOf: url))
        for fixture in fixtures.games {
            let link = MatchTestLink()
            let host = LocalMatchSession(transport: link.white)
            let guest = LocalMatchSession(transport: link.black)
            let variant = try XCTUnwrap(Variant(rawValue: fixture.preset))
            host.host(variant: variant)
            guest.browse()
            guest.join(NearbyGame(id: "test", matchID: try XCTUnwrap(host.identity).id, variant: variant))
            link.connect(); link.pump(); host.acceptInvitation(); link.pump()
            let white = GameStore(inMemory: true), black = GameStore(inMemory: true)
            white.adoptNetwork(host); black.adoptNetwork(guest)
            for notation in fixture.moves {
                let actor = host.position?.side == 0 ? white : black
                let other = host.position?.side == 0 ? black : white
                XCTAssertTrue(actor.isHumanTurn, fixture.name)
                XCTAssertFalse(other.isHumanTurn)
                XCTAssertFalse(actor.canUndo)
                XCTAssertFalse(actor.canHint)
                actor.toggleHint(); actor.undo()
                XCTAssertFalse(actor.isThinking)
                let action = try XCTUnwrap(actor.position?.legal.first { $0.notation == notation })
                let count = actor.game?.moves.count
                other.play(action)
                XCTAssertEqual(actor.game?.moves.count, count)
                if action.kind == 1 { actor.tap(action.from) }
                actor.tap(action.to)
                XCTAssertFalse(actor.isHumanTurn, "Wait for the authoritative snapshot/acknowledgement")
                link.pump()
                XCTAssertEqual(host.phase, .connected)
                XCTAssertEqual(guest.phase, .connected)
                XCTAssertEqual(white.game?.moves, black.game?.moves)
                XCTAssertEqual(white.position?.fen, black.position?.fen)
                XCTAssertEqual(white.position?.legal, black.position?.legal)
            }
            XCTAssertEqual(host.position?.fen, fixture.fen, fixture.name)
            XCTAssertEqual(guest.position?.outcome, fixture.outcome, fixture.name)
            XCTAssertFalse(host.canPlay); XCTAssertFalse(guest.canPlay)
            XCTAssertTrue(white.hasUnacknowledgedResult); XCTAssertTrue(black.hasUnacknowledgedResult)
            white.acknowledgeResult(); black.acknowledgeResult()
            // Session snapshots do not own the local UI acknowledgement.
            host.onUpdate?(try XCTUnwrap(host.game), try XCTUnwrap(host.position))
            guest.onUpdate?(try XCTUnwrap(guest.game), try XCTUnwrap(guest.position))
            XCTAssertFalse(white.hasUnacknowledgedResult); XCTAssertFalse(black.hasUnacknowledgedResult)
            host.stop(); guest.stop()
        }
    }

    @MainActor func testNetworkRelaunchRecoversUnacknowledgedMoveWithoutDuplicatingIt() throws {
        let link = MatchTestLink()
        let host = LocalMatchSession(transport: link.white), guest = LocalMatchSession(transport: link.black)
        host.host(variant: .lasker); guest.browse()
        guest.join(NearbyGame(id: "test", matchID: try XCTUnwrap(host.identity).id, variant: .lasker))
        link.connect(); link.pump(); host.acceptInvitation(); link.pump()
        let whiteFile = URL.temporaryDirectory.appending(path: UUID().uuidString + ".json")
        let blackFile = URL.temporaryDirectory.appending(path: UUID().uuidString + ".json")
        defer { try? FileManager.default.removeItem(at: whiteFile); try? FileManager.default.removeItem(at: blackFile) }
        let white = GameStore(storageURL: whiteFile), black = GameStore(storageURL: blackFile)
        white.adoptNetwork(host); black.adoptNetwork(guest)
        let action = try XCTUnwrap(host.position?.legal.first)
        white.play(action)
        // Simulate a lost connection after the host saved a move, before the guest received it.
        link.pending.removeAll(); host.pause(); guest.pause(); link.pending.removeAll()
        let restoredWhite = GameStore(storageURL: whiteFile), restoredBlack = GameStore(storageURL: blackFile)
        XCTAssertEqual(restoredWhite.game?.moves.count, 1)
        XCTAssertEqual(restoredBlack.game?.moves.count, 0)
        XCTAssertFalse(restoredWhite.isHumanTurn); XCTAssertFalse(restoredBlack.isHumanTurn)
        XCTAssertFalse(restoredWhite.canUndo); XCTAssertFalse(restoredBlack.canHint)
        let recoveredHost = try LocalMatchSession(restoring: XCTUnwrap(restoredWhite.game), transport: link.white)
        let recoveredGuest = try LocalMatchSession(restoring: XCTUnwrap(restoredBlack.game), transport: link.black)
        recoveredHost.reconnect(); recoveredGuest.reconnect()
        link.black.onGames?([NearbyGame(id: "test", matchID: try XCTUnwrap(host.identity).id, variant: .lasker)])
        link.connect(); link.pump()
        XCTAssertTrue(recoveredHost.hasStarted)
        XCTAssertEqual(recoveredGuest.phase, .connected, "The original partner resumes without another invitation")
        XCTAssertEqual(recoveredHost.game?.moves, recoveredGuest.game?.moves)
        XCTAssertEqual(recoveredGuest.game?.moves.count, 1)
        XCTAssertEqual(recoveredHost.position?.fen, recoveredGuest.position?.fen)
        recoveredHost.stop(); recoveredGuest.stop()
    }

    @MainActor func testNetworkRejectsOutOfTurnAndCorruptPackets() throws {
        let link = MatchTestLink()
        let host = LocalMatchSession(transport: link.white), guest = LocalMatchSession(transport: link.black)
        host.host(variant: .classic); guest.browse()
        guest.join(NearbyGame(id: "test", matchID: try XCTUnwrap(host.identity).id, variant: .classic))
        link.connect(); link.pump(); host.acceptInvitation(); link.pump()
        let game = try XCTUnwrap(guest.game), identity = try XCTUnwrap(guest.identity), position = try XCTUnwrap(guest.position)
        let snapshot = LocalMatchSnapshot(id: identity.id, resumeKey: identity.resumeKey, variant: .classic, moves: [], fen: position.fen)
        let illegalTurn = LocalMatchPacket(event: .move(revision: 0, digest: snapshot.digest, action: try XCTUnwrap(position.legal.first)))
        link.white.onData?(try illegalTurn.encoded())
        XCTAssertEqual(host.failure, .invalidGame)
        XCTAssertEqual(host.game?.moves, game.moves)
        var incompatible = LocalMatchPacket(event: .pause)
        incompatible.version += 1
        XCTAssertThrowsError(try LocalMatchPacket.decode(incompatible.encoded()))
        XCTAssertThrowsError(try LocalMatchPacket.decode(Data(repeating: 0, count: LocalMatchPacket.maximumBytes + 1)))
        let invalid = LocalMatchSnapshot(id: identity.id, resumeKey: identity.resumeKey, variant: .classic,
                                        moves: [MoveRecord(notation: "a7", side: 1)], fen: position.fen)
        XCTAssertThrowsError(try invalid.validatedGame(previous: game))
        host.stop(); guest.stop()
    }

    @MainActor func testNetworkDeclinedInvitationLeavesExistingGameUntouched() throws {
        let store = GameStore(inMemory: true)
        store.start(GameSettings(opponent: .local))
        store.play(try XCTUnwrap(store.position?.legal.first))
        let original = store.game?.moves
        let link = MatchTestLink()
        let host = LocalMatchSession(transport: link.white), guest = LocalMatchSession(transport: link.black)
        host.host(variant: .classic); guest.browse()
        guest.join(NearbyGame(id: "test", matchID: try XCTUnwrap(host.identity).id, variant: .classic))
        link.connect(); link.pump(); host.declineInvitation(); link.pump()
        store.adoptNetwork(guest)
        XCTAssertNil(store.network)
        XCTAssertEqual(store.game?.moves, original)
        XCTAssertFalse(guest.hasStarted)
        XCTAssertEqual(guest.failure, .declined)
        host.stop(); guest.stop()
    }


    func testNativeLocalizationsAreBundledCompleteAndUseValidFormats() throws {
        let languages = ["de", "en", "es", "fr", "ja", "ko", "zh-Hans", "zh-Hant"]
        func strings(_ language: String) throws -> [String: String] {
            let directory = try XCTUnwrap(Bundle.main.path(forResource: language, ofType: "lproj"))
            let bundle = try XCTUnwrap(Bundle(path: directory))
            let url = try XCTUnwrap(bundle.url(forResource: "Localizable", withExtension: "strings"))
            return try XCTUnwrap(PropertyListSerialization.propertyList(from: Data(contentsOf: url), format: nil) as? [String: String])
        }
        let english = try strings("en")
        XCTAssertEqual(english.count, 230)
        let format = try NSRegularExpression(pattern: "%[@d]")
        func arguments(_ value: String) -> [String] {
            format.matches(in: value, range: NSRange(value.startIndex..., in: value))
                .map { String(value[Range($0.range, in: value)!]) }
        }
        for language in languages {
            XCTAssertTrue(Bundle.main.localizations.contains(language), language)
            let translated = try strings(language)
            XCTAssertEqual(Set(translated.keys), Set(english.keys), language)
            for (key, value) in translated {
                XCTAssertFalse(value.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty, "\(language)/\(key)")
                XCTAssertEqual(arguments(value), arguments(english[key] ?? ""), "\(language)/\(key)")
            }
            // Each paragraph is paired with its own localized heading in About.
            for key in ["privacy_body", "credits_body"] {
                XCTAssertEqual(translated[key]?.components(separatedBy: "\n\n").count, 3, "\(language)/\(key)")
            }
            if language != "en" {
                for key in ["new_game", "start_game", "rules", "computer_help_body", "privacy_body"] {
                    XCTAssertNotEqual(translated[key], english[key], "\(language)/\(key)")
                }
            }
        }
    }

    func testBuildInformationUsesBundleValuesAndLicensesAreBundled() throws {
        let build = AppInformation.Build(info: ["CFBundleShortVersionString": "1.2.3", "CFBundleVersion": "42", "CFBundleIdentifier": "test.app"])
        XCTAssertEqual(build.version, "1.2.3")
        XCTAssertEqual(build.number, "42")
        XCTAssertEqual(build.identifier, "test.app")
        XCTAssertEqual(AppInformation.Build(info: [:]).number, "–")
        XCTAssertFalse(AppInformation.build.version.contains("$("))
        XCTAssertFalse(AppInformation.build.number.contains("$("))
        let notices = try LicenseNotice.load()
        XCTAssertEqual(notices.count, 20)
        XCTAssertTrue(notices.contains { $0.title == "Sanmill" && $0.text?.contains("additional permission") == true })
        XCTAssertTrue(notices.contains { $0.title.hasPrefix("unicode-ident") && $0.text?.contains("UNICODE") == true })
        let rust = try XCTUnwrap(notices.first { $0.title.hasPrefix("Rust ") })
        XCTAssertGreaterThan(try XCTUnwrap(rust.children).count, 100)
        for item in rust.children ?? [] {
            XCTAssertFalse(item.text?.isEmpty ?? true)
            XCTAssertLessThanOrEqual(item.text?.count ?? 0, 24000)
        }
    }

    func testLicenseReflowPreservesEveryBundledNonWhitespaceCharacter() throws {
        let url = try XCTUnwrap(Bundle.main.url(forResource: "AGPL-3.0", withExtension: "txt"))
        var documents = [try String(contentsOf: url, encoding: .utf8)]
        func collect(_ entries: [LicenseNotice]) {
            for entry in entries {
                if let text = entry.text { documents.append(text) }
                if let children = entry.children { collect(children) }
            }
        }
        collect(try LicenseNotice.load())
        XCTAssertGreaterThan(documents.count, 170)
        for original in documents {
            let reflowed = LicenseText.blocks(original).map(\.text).joined(separator: "\n")
            XCTAssertEqual(reflowed.filter { !$0.isWhitespace }, original.filter { !$0.isWhitespace },
                           "Reflow must never remove or change notice wording")
        }
    }

    func testLicenseReflowKeepsClausesListsAndLiteralExamples() {
        let source = """
          1. Definitions.

          A paragraph with a fixed
        line length and a non-
        exclusive permission.

          a) First condition that continues
             on the next source line.
          b) Second condition.

        ```
        first line
          indented example
        ```
        """
        let blocks = LicenseText.blocks(source)
        XCTAssertEqual(blocks[0].kind, .heading)
        XCTAssertEqual(blocks[1].text, "A paragraph with a fixed line length and a non-exclusive permission.")
        XCTAssertEqual(blocks[2].kind, .listItem)
        XCTAssertEqual(blocks[2].text, "a) First condition that continues on the next source line.")
        XCTAssertEqual(blocks[3].text, "b) Second condition.")
        XCTAssertTrue(blocks.contains { $0.kind == .literal && $0.text == "  indented example" })
    }

    @MainActor func testProgressDelayDoesNotFlashAndCancelsPendingTimer() async throws {
        let progress = DelayedSearchProgress()
        progress.start(after: .milliseconds(80))
        XCTAssertFalse(progress.isVisible)
        progress.finish()
        try await Task.sleep(for: .milliseconds(120))
        XCTAssertFalse(progress.isVisible, "A completed quick search must not show progress later")
        progress.start(after: .milliseconds(20))
        try await Task.sleep(for: .milliseconds(70))
        XCTAssertTrue(progress.isVisible)
        progress.start(after: .milliseconds(100))
        XCTAssertFalse(progress.isVisible, "A new search starts with a fresh delay")
        progress.finish()
        try await Task.sleep(for: .milliseconds(140))
        XCTAssertFalse(progress.isVisible)
    }

    @MainActor func testHintCarriesExplanationWithoutChangingTheGame() async throws {
        let store = GameStore(inMemory: true)
        store.start(GameSettings(opponent: .local, level: 4))
        let before = store.position?.fen
        store.toggleHint()
        XCTAssertFalse(store.searchProgress.isVisible)
        try await waitForHuman(store)
        XCTAssertEqual(store.hint?.notation, "d2")
        XCTAssertEqual(store.hintExplanation?.source, "book")
        XCTAssertEqual(store.hintExplanation?.action, store.hint)
        XCTAssertEqual(store.position?.fen, before)
        XCTAssertTrue(store.game?.moves.isEmpty == true)
        XCTAssertFalse(store.searchProgress.isVisible)
        store.toggleHint()
        XCTAssertNil(store.hint)
        XCTAssertNil(store.hintExplanation)
        XCTAssertFalse(store.isThinking)
        XCTAssertEqual(store.position?.fen, before)
        store.toggleHint()
        try await waitForHuman(store)
        XCTAssertNotNil(store.hintExplanation)
        store.tap(23)
        XCTAssertNil(store.hint)
        XCTAssertNil(store.hintExplanation)
        XCTAssertEqual(store.game?.moves.count, 1)
    }

    @MainActor func testHidingMovingHintClearsSelectionAndPendingResult() async throws {
        let url = try XCTUnwrap(Bundle(for: Self.self).url(forResource: "offline-games", withExtension: "json"))
        let fixtures = try JSONDecoder().decode(OfflineFixtures.self, from: Data(contentsOf: url))
        let fixture = try XCTUnwrap(fixtures.games.first { $0.preset == 0 })
        let store = GameStore(inMemory: true)
        store.start(GameSettings(opponent: .local, level: 1))
        for notation in fixture.moves {
            if store.position?.legal.allSatisfy({ $0.kind == 1 }) == true { break }
            store.play(try XCTUnwrap(store.position?.legal.first { $0.notation == notation }))
        }
        let before = store.position?.fen
        let moves = store.game?.moves
        store.toggleHint()
        try await waitForHuman(store)
        let hint = try XCTUnwrap(store.hint)
        XCTAssertEqual(hint.kind, 1)
        XCTAssertEqual(store.selectedNode, hint.from)
        store.toggleHint()
        XCTAssertNil(store.hint)
        XCTAssertNil(store.hintExplanation)
        XCTAssertNil(store.selectedNode)
        store.toggleHint()
        XCTAssertEqual(store.activity, .hint)
        store.toggleHint()
        XCTAssertFalse(store.isThinking)
        try await Task.sleep(for: .milliseconds(350))
        XCTAssertNil(store.hint)
        XCTAssertNil(store.hintExplanation)
        XCTAssertNil(store.selectedNode)
        XCTAssertFalse(store.searchProgress.isVisible)
        XCTAssertEqual(store.position?.fen, before)
        XCTAssertEqual(store.game?.moves, moves)
    }

    func testGridPagesKeepEveryMoveInOrderAtEverySize() {
        for size in [CGSize(width: 375, height: 370), CGSize(width: 540, height: 370), CGSize(width: 667, height: 205)] {
            for scale: CGFloat in [1, 3.12] {
                for count in [0, 8, 24, 120] {
                    let layout = GridPageLayout(size: size, itemCount: count, minimumWidth: 150 * scale,
                        rowHeight: max(44, 22 * scale + 16), maximumColumns: 3, footerHeight: max(44, 22 * scale))
                    XCTAssertEqual((0..<layout.pageCount).flatMap { Array(layout.indices(page: $0, count: count)) }, Array(0..<count))
                    XCTAssertEqual(layout.indices(page: 10000, count: count), layout.indices(page: layout.pageCount - 1, count: count))
                    if scale == 1 && size.width == 375 { XCTAssertEqual(layout.columns, 2) }
                    if scale == 1 && size.width == 540 { XCTAssertEqual(layout.columns, 3) }
                }
            }
        }
    }

    private struct OfflineFixtures: Decodable {
        struct Game: Decodable {
            let name: String
            let preset: Int
            let moves: [String]
            let outcome: String
            let winner: Int
            let reason: String
            let fen: String
        }
        let games: [Game]
    }
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
        let saved = SavedGame(settings: GameSettings(level: 2), moves: records)
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
        XCTAssertFalse(preferences.showLegalMoves)
        XCTAssertFalse(preferences.showLastMove)
        XCTAssertTrue(preferences.animateStones)
        XCTAssertEqual(preferences.accentPalette, .slate)
        preferences.showLegalMoves = true
        preferences.showLastMove = true
        preferences.animateStones = false
        let restored = AppPreferences(defaults: defaults)
        XCTAssertTrue(restored.showLegalMoves)
        XCTAssertTrue(restored.showLastMove)
        XCTAssertFalse(restored.animateStones)
        for palette in AccentPalette.allCases {
            preferences.accentPalette = palette
            XCTAssertEqual(AppPreferences(defaults: defaults).accentPalette, palette)
            XCTAssertFalse(AppPreferences(defaults: defaults).animateStones)
        }
        defaults.set("unknown-palette", forKey: "accentPalette")
        XCTAssertEqual(AppPreferences(defaults: defaults).accentPalette, .slate)
    }

    @MainActor func testComputerLevelDefaultsToOneAndPersists() throws {
        let suite = "MuehlensteinTests.\(UUID().uuidString)"
        let defaults = try XCTUnwrap(UserDefaults(suiteName: suite))
        defer { defaults.removePersistentDomain(forName: suite) }
        XCTAssertEqual(GameSettings().level, 1)
        let preferences = AppPreferences(defaults: defaults)
        XCTAssertEqual(preferences.lastComputerLevel, 1)
        for level in GameSettings.levels {
            preferences.lastComputerLevel = level
            XCTAssertEqual(AppPreferences(defaults: defaults).lastComputerLevel, level)
        }
        for invalidLevel in [0, 6, -1] {
            defaults.set(invalidLevel, forKey: "lastComputerLevel")
            XCTAssertEqual(AppPreferences(defaults: defaults).lastComputerLevel, 1)
        }
    }

    func testBeginnerOpponentIsSeparateFromUsefulHints() throws {
        let moves = ["a7", "c5", "d7", "d5", "g1"].enumerated().map { MoveRecord(notation: $0.element, side: $0.offset % 2) }
        let game = SavedGame(settings: GameSettings(level: 1, effort: .extended, style: .blocking), moves: moves)
        let opponent = try Engine.query(game, search: true)
        XCTAssertEqual(opponent.moveSource, "beginner")
        XCTAssertEqual(opponent.searchDepth, 0)
        XCTAssertEqual(opponent.searchNodes, 0)
        XCTAssertTrue(opponent.legal.contains(try XCTUnwrap(opponent.best)))
        let hint = try Engine.query(game, search: true, isHint: true)
        XCTAssertEqual(hint.moveSource, "search")
        XCTAssertTrue(hint.moveInsights?.contains(where: { ["mill", "blocks_line"].contains($0) }) == true)
        XCTAssertGreaterThan(hint.searchDepth, 0)
        XCTAssertEqual(hint.fen, opponent.fen)
        XCTAssertEqual(hint.actors, moves.map(\.side))
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
    func testOpeningBookPolicyAndPersistence() throws {
        var game = SavedGame(settings: GameSettings(level: 4), moves: [MoveRecord(notation: "b4", side: 0)])
        let book = try Engine.query(game, search: true)
        XCTAssertEqual(book.moveSource, "book")
        XCTAssertEqual(book.searchNodes, 0)
        XCTAssertTrue(book.legal.contains(try XCTUnwrap(book.best)))
        game.settings.openingBook = false
        let restored = try JSONDecoder().decode(SavedGame.self, from: JSONEncoder().encode(game))
        XCTAssertFalse(restored.settings.openingBook)
        let searched = try Engine.query(restored, search: true)
        XCTAssertEqual(searched.moveSource, "search")
        XCTAssertEqual(book.fen, searched.fen)
        XCTAssertEqual(book.legal, searched.legal)
        game.settings.openingBook = true
        game.settings.level = 3
        XCTAssertEqual(try Engine.query(game, search: true).moveSource, "search")
        game.settings.variant = .twelve
        game.settings.level = 4
        XCTAssertEqual(try Engine.query(game, search: true).moveSource, "search")
    }

    func testComputerStylesPersistWithoutChangingRules() throws {
        for variant in Variant.allCases {
            let moves = [MoveRecord(notation: "a7", side: 0), MoveRecord(notation: "g7", side: 1)]
            let balanced = SavedGame(settings: GameSettings(variant: variant), moves: moves)
            var blocking = balanced
            blocking.settings.style = .blocking
            let restored = try JSONDecoder().decode(SavedGame.self, from: JSONEncoder().encode(blocking))
            XCTAssertEqual(restored.settings.style, .blocking)
            let before = try Engine.query(balanced)
            let after = try Engine.query(restored)
            XCTAssertEqual(before.fen, after.fen)
            XCTAssertEqual(before.legal, after.legal)
            XCTAssertEqual(before.actors, after.actors)
        }
        let settings = Data(#"{"variant":0,"opponent":"computer","level":3,"algorithm":"mtdf","effort":"standard"}"#.utf8)
        XCTAssertEqual(try JSONDecoder().decode(GameSettings.self, from: settings).style, .balanced)
    }

    @MainActor func testChangingComputerSettingsRestartsPendingSearchAndPreservesGame() async throws {
        let file = URL.temporaryDirectory.appending(path: UUID().uuidString + ".json")
        defer { try? FileManager.default.removeItem(at: file) }
        let store = GameStore(storageURL: file, pacing: ComputerPacing(fixedDelay: .milliseconds(500)))
        store.start(GameSettings(level: 5))
        store.tap(23)
        XCTAssertTrue(store.isThinking)
        // Only computer configuration may change; variant and opponent must be preserved.
        store.updateComputerSettings(GameSettings(variant: .lasker, opponent: .local, level: 1, algorithm: .pvs, effort: .extended, style: .blocking, openingBook: false))
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
        XCTAssertEqual(restored.game?.settings.style, .blocking)
        XCTAssertEqual(restored.game?.settings.openingBook, false)
        XCTAssertEqual(restored.game?.moves, store.game?.moves)
    }

    @MainActor func testCompleteArchivedGamesRestoreAfterEveryActionAndUndoToOpening() throws {
        let url = try XCTUnwrap(Bundle(for: Self.self).url(forResource: "offline-games", withExtension: "json"))
        let fixtures = try JSONDecoder().decode(OfflineFixtures.self, from: Data(contentsOf: url))
        XCTAssertEqual(fixtures.games.count, 18)
        let file = URL.temporaryDirectory.appending(path: UUID().uuidString + ".json")
        defer { try? FileManager.default.removeItem(at: file) }
        for fixture in fixtures.games {
            var store = GameStore(storageURL: file)
            store.start(GameSettings(variant: try XCTUnwrap(Variant(rawValue: fixture.preset)), opponent: .local))
            let opening = try XCTUnwrap(store.position)
            for notation in fixture.moves {
                XCTAssertTrue(store.hasOngoingGame, fixture.name)
                let action = try XCTUnwrap(store.position?.legal.first { $0.notation == notation }, "\(fixture.name): \(notation)")
                if action.kind == 1 { store.tap(action.from) }
                store.tap(action.to)
                XCTAssertEqual(store.game?.moves.last?.notation, notation)
                XCTAssertNil(store.errorMessage)
                let replayGame = try XCTUnwrap(store.game)
                let replay = try replayGame.replay(at: replayGame.historyEntries.count)
                XCTAssertEqual(replay.position.fen, store.position?.fen, fixture.name)
                XCTAssertEqual(replay.highlight, action, fixture.name)
                let restored = GameStore(storageURL: file)
                XCTAssertNil(restored.errorMessage)
                XCTAssertEqual(restored.game?.moves, store.game?.moves)
                XCTAssertEqual(restored.position?.fen, store.position?.fen)
                XCTAssertEqual(restored.position?.legal, store.position?.legal)
                XCTAssertEqual(restored.position?.lastTurn, store.position?.lastTurn)
                store = restored
            }
            XCTAssertEqual(store.position?.outcome, fixture.outcome, fixture.name)
            XCTAssertFalse(store.hasOngoingGame, fixture.name)
            XCTAssertEqual(store.position?.winner, fixture.winner, fixture.name)
            XCTAssertEqual(store.position?.reason, fixture.reason, fixture.name)
            XCTAssertEqual(store.position?.fen, fixture.fen, fixture.name)
            XCTAssertTrue(store.position?.legal.isEmpty == true)
            XCTAssertTrue(store.hasUnacknowledgedResult, fixture.name)
            store.acknowledgeResult()
            XCTAssertFalse(store.hasUnacknowledgedResult)
            XCTAssertFalse(GameStore(storageURL: file).hasUnacknowledgedResult)
            store.tap(23)
            store.toggleHint()
            store.resumeComputer()
            XCTAssertFalse(store.isThinking)
            XCTAssertEqual(store.game?.moves.count, fixture.moves.count)
            store.undo()
            XCTAssertFalse(try XCTUnwrap(store.position).isOver)
            XCTAssertTrue(store.hasOngoingGame, fixture.name)
            let last = try XCTUnwrap(store.position?.legal.first { $0.notation == fixture.moves.last })
            store.play(last)
            XCTAssertEqual(store.position?.reason, fixture.reason)
            XCTAssertTrue(store.hasUnacknowledgedResult, "Replaying an undone finish must announce the new result")
            for _ in fixture.moves { store.undo() }
            XCTAssertTrue(store.game?.moves.isEmpty == true)
            XCTAssertEqual(store.position?.fen, opening.fen)
            XCTAssertFalse(store.canUndo)
        }
    }

    func testStoneIdentitiesFollowReferenceMovesCapturesAndUndo() throws {
        let url = try XCTUnwrap(Bundle(for: Self.self).url(forResource: "offline-games", withExtension: "json"))
        let fixtures = try JSONDecoder().decode(OfflineFixtures.self, from: Data(contentsOf: url))
        var moved = 0
        var captured = 0
        for fixture in fixtures.games {
            var game = SavedGame(settings: GameSettings(variant: try XCTUnwrap(Variant(rawValue: fixture.preset)), opponent: .local))
            var position = try Engine.query(game)
            for notation in fixture.moves {
                let before = try XCTUnwrap(BoardPiece.tracked(position: position, moves: game.moves))
                let action = try XCTUnwrap(position.legal.first { $0.notation == notation })
                game.moves.append(MoveRecord(notation: notation, side: position.side))
                let next = try Engine.query(game)
                let after = try XCTUnwrap(BoardPiece.tracked(position: next, moves: game.moves), fixture.name + ": " + notation)
                XCTAssertEqual(Set(after.map(\.id)).count, after.count)
                switch action.kind {
                case 0:
                    XCTAssertEqual(after.count, before.count + 1)
                    XCTAssertEqual(after.first { $0.node == action.to }?.side, position.side)
                case 1:
                    moved += 1
                    XCTAssertEqual(after.count, before.count)
                    XCTAssertEqual(before.first { $0.node == action.from }?.id, after.first { $0.node == action.to }?.id)
                    XCTAssertNil(after.first { $0.node == action.from })
                default:
                    captured += 1
                    let removed = try XCTUnwrap(before.first { $0.node == action.to })
                    XCTAssertEqual(Set(after.map(\.id)), Set(before.map(\.id)).subtracting([removed.id]))
                }
                // Undo reconstructs the original identities, including a stone returned after capture.
                XCTAssertEqual(BoardPiece.tracked(position: position, moves: Array(game.moves.dropLast())), before)
                position = next
            }
        }
        XCTAssertGreaterThan(moved, 100)
        XCTAssertGreaterThan(captured, 20)
    }

    @MainActor func testNewGameResetsVisualIdentityButMovesAndUndoDoNot() throws {
        let store = GameStore(inMemory: true)
        XCTAssertFalse(store.hasOngoingGame)
        store.start(GameSettings(opponent: .local))
        XCTAssertTrue(store.hasOngoingGame)
        let identity = store.boardID
        store.tap(23)
        XCTAssertEqual(store.boardID, identity)
        store.undo()
        XCTAssertEqual(store.boardID, identity)
        store.start(GameSettings(opponent: .local))
        XCTAssertNotEqual(store.boardID, identity)
    }

    @MainActor func testExplicitActionIgnoresSelectionAndRejectsStaleAndIllegalMoves() throws {
        let store = GameStore(inMemory: true)
        store.start(GameSettings(variant: .lasker, opponent: .local))
        store.tap(try XCTUnwrap(store.position?.nodes.first { $0.label == "a7" }?.id))
        store.tap(try XCTUnwrap(store.position?.nodes.first { $0.label == "g7" }?.id))
        let action = try XCTUnwrap(store.position?.legal.first { $0.notation == "a7-d7" })
        store.tap(action.from)
        XCTAssertEqual(store.selectedNode, action.from)
        let hand = store.position?.hand
        store.play(action)
        XCTAssertEqual(store.game?.moves.last?.notation, "a7-d7")
        XCTAssertEqual(store.position?.hand, hand)
        XCTAssertNil(store.selectedNode)
        let moves = store.game?.moves
        store.play(action) // Old list entry after the turn changed.
        store.play(EngineAction(kind: 0, from: -1, to: 99, notation: "z9"))
        XCTAssertEqual(store.game?.moves, moves)
        XCTAssertNil(store.errorMessage)
    }

    @MainActor func testInvalidSaveMetadataAndTranscriptsArePreserved() throws {
        let file = URL.temporaryDirectory.appending(path: UUID().uuidString + ".json")
        defer { try? FileManager.default.removeItem(at: file) }
        var wrongSchema = SavedGame(settings: GameSettings()); wrongSchema.schema = 1
        var wrongEngine = SavedGame(settings: GameSettings()); wrongEngine.engineRevision = "unknown"
        let wrongActor = SavedGame(settings: GameSettings(), moves: [MoveRecord(notation: "a7", side: 1)])
        let illegalMoves = SavedGame(settings: GameSettings(), moves: [MoveRecord(notation: "a7", side: 0), MoveRecord(notation: "a7", side: 1)])
        for saved in [wrongSchema, wrongEngine, wrongActor, illegalMoves, SavedGame(settings: GameSettings(level: 6))] {
            let data = try JSONEncoder().encode(saved)
            try data.write(to: file)
            let store = GameStore(storageURL: file)
            XCTAssertNil(store.game)
            XCTAssertNil(store.position)
            XCTAssertNotNil(store.errorMessage)
            XCTAssertEqual(try Data(contentsOf: file), data)
        }
    }

    @MainActor func testRestartBetweenMorabarabaCapturesKeepsTurnAndUndoHistory() throws {
        let file = URL.temporaryDirectory.appending(path: UUID().uuidString + ".json")
        defer { try? FileManager.default.removeItem(at: file) }
        var store = GameStore(storageURL: file)
        store.start(GameSettings(variant: .morabaraba, opponent: .local))
        for notation in ["b6", "a7", "f6", "g7", "d7", "a1", "d5", "g1", "d6", "xa7"] {
            store.play(try XCTUnwrap(store.position?.legal.first { $0.notation == notation }))
        }
        store = GameStore(storageURL: file)
        XCTAssertEqual(store.position?.side, 0)
        XCTAssertEqual(store.position?.action, 2)
        XCTAssertEqual(store.position?.lastTurn.map(\.notation), ["d6", "xa7"])
        store.play(try XCTUnwrap(store.position?.legal.first { $0.notation == "xg7" }))
        XCTAssertEqual(store.position?.side, 1)
        store.undo()
        XCTAssertEqual(store.position?.side, 0)
        XCTAssertEqual(store.position?.action, 2)
        XCTAssertEqual(store.game?.moves.last?.notation, "xa7")
    }

    @MainActor func testComputerCanRestartFromInterruptedMillAndUndoWholeRound() async throws {
        let file = URL.temporaryDirectory.appending(path: UUID().uuidString + ".json")
        defer { try? FileManager.default.removeItem(at: file) }
        let moves = ["a7", "c5", "d7", "d5", "g1", "e5"]
        let saved = SavedGame(settings: GameSettings(level: 1), moves: moves.enumerated().map { MoveRecord(notation: $0.element, side: $0.offset % 2) })
        try JSONEncoder().encode(saved).write(to: file)
        let store = GameStore(storageURL: file, pacing: ComputerPacing(fixedDelay: .milliseconds(250)))
        XCTAssertEqual(store.position?.action, 2)
        store.resumeComputer()
        let pendingMoves = store.game?.moves
        store.undo() // Locked while a computer action is being presented.
        store.play(try XCTUnwrap(store.position?.legal.first))
        XCTAssertEqual(store.game?.moves, pendingMoves)
        store.suspend()
        try await Task.sleep(for: .milliseconds(300))
        XCTAssertEqual(store.game?.moves, pendingMoves)
        let restored = GameStore(storageURL: file, pacing: ComputerPacing(fixedDelay: .milliseconds(10)))
        restored.resumeComputer()
        try await waitForHuman(restored)
        XCTAssertEqual(restored.game?.moves.count, 7)
        XCTAssertEqual(restored.position?.lastTurn.count, 2)
        restored.undo()
        XCTAssertEqual(restored.game?.moves.map(\.notation), Array(moves.prefix(4)))
        XCTAssertEqual(restored.position?.side, 0)
        XCTAssertNil(restored.errorMessage)
    }

    @MainActor func testCancelledHintCannotChangeReplacementGame() async throws {
        let store = GameStore(inMemory: true)
        store.start(GameSettings(level: 5, effort: .extended))
        store.toggleHint()
        XCTAssertEqual(store.activity, .hint)
        store.suspend()
        store.start(GameSettings(variant: .twelve, opponent: .local))
        try await Task.sleep(for: .milliseconds(400))
        XCTAssertNil(store.hint)
        XCTAssertNil(store.selectedNode)
        XCTAssertNil(store.errorMessage)
        XCTAssertFalse(store.isThinking)
        XCTAssertEqual(store.game?.settings.variant, .twelve)
        XCTAssertTrue(store.game?.moves.isEmpty == true)
    }

    private func measureSearch(level: Int, effort: SearchEffort) {
        let moves = ["a7", "f6", "d6", "g1", "c5", "d3"]
        let game = SavedGame(settings: GameSettings(level: level, effort: effort), moves:
            moves.enumerated().map { MoveRecord(notation: $0.element, side: $0.offset % 2) })
        let options = XCTMeasureOptions()
        options.iterationCount = 5
        // Measures calculation, including its TT allocation; intentional UI pacing is excluded.
        measure(metrics: [XCTClockMetric(), XCTCPUMetric(), XCTMemoryMetric()], options: options) {
            do {
                let result = try Engine.query(game, search: true)
                XCTAssertTrue(result.legal.contains(try XCTUnwrap(result.best)))
            } catch { XCTFail("Measured search failed: \(error)") }
        }
    }
    func testPerformanceStandardSearch() { measureSearch(level: 3, effort: .standard) }
    func testPerformanceExtendedSearch() { measureSearch(level: 5, effort: .extended) }

}

/// Deliberately queued transport: assertions can observe dropped acknowledgements and pending moves.
@MainActor private final class MatchTestLink {
    let white = MatchTestTransport(), black = MatchTestTransport()
    var pending: [() -> Void] = []
    init() {
        white.deliver = { [weak self] data in self?.pending.append { [weak self] in self?.black.onData?(data) } }
        black.deliver = { [weak self] data in self?.pending.append { [weak self] in self?.white.onData?(data) } }
    }
    func connect() { white.onConnected?(); black.onConnected?() }
    func pump() {
        var count = 0
        while !pending.isEmpty && count < 30 { let delivery = pending.removeFirst(); delivery(); count += 1 }
        XCTAssertLessThan(count, 30, "Protocol must not echo indefinitely")
    }
}
@MainActor private final class MatchTestTransport: MatchTransport {
    var onGames: (([NearbyGame]) -> Void)?
    var onConnected: (() -> Void)?
    var onDisconnected: (() -> Void)?
    var onData: ((Data) -> Void)?
    var onFailure: (() -> Void)?
    var deliver: ((Data) -> Void)?
    func host(id: UUID, variant: Variant) {}
    func browse() {}
    func connect(to game: NearbyGame) {}
    func send(_ data: Data) throws { deliver?(data) }
    func stop() {}
}
