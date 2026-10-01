// SPDX-License-Identifier: AGPL-3.0-or-later
import Foundation
import Observation

@MainActor @Observable final class GameStore {
    private(set) var game: SavedGame?
    private(set) var position: Position?
    private(set) var boardID = UUID()
    enum Activity { case computer, hint }
    private(set) var activity: Activity?
    var isThinking: Bool { activity != nil }
    var selectedNode: Int?
    var hint: EngineAction? { didSet { if hint != oldValue { hintExplanation = nil } } }
    private(set) var hintExplanation: HintExplanation?
    let searchProgress = DelayedSearchProgress()
    var errorMessage: String?
    private var generation = UUID()
    private var worker: Task<Void, Never>?
    private let saveURL: URL
    private let usesDisk: Bool
    private let pacing: ComputerPacing
    private var activeSearch: SearchCancellation?

    init(inMemory: Bool = false, storageURL: URL? = nil, pacing: ComputerPacing = .natural) {
        self.pacing = pacing
        usesDisk = !inMemory
        saveURL = storageURL ?? URL.applicationSupportDirectory.appending(path: "Muehlenstein/current-game.json")
        guard !inMemory, FileManager.default.fileExists(atPath: saveURL.path) else { return }
        do {
            let saved = try JSONDecoder().decode(SavedGame.self, from: Data(contentsOf: saveURL))
            guard saved.schema == 2, saved.engineRevision == "8901a06f088bf49a1602fee8686ed25ac5a33925" else {
                throw EngineError.rejected("saveVersion")
            }
            // The Rust replay validates the whole transcript before accepting it.
            position = try Engine.query(saved)
            game = saved
        } catch { errorMessage = L10n.text("restore_error") }
    }
    var isHumanTurn: Bool {
        guard let game, let position, !position.isOver else { return false }
        return game.settings.opponent == .local || position.side == 0
    }
    var canUndo: Bool { !(game?.moves.isEmpty ?? true) && !isThinking }
    var hasOngoingGame: Bool { position?.isOver == false }

    func start(_ settings: GameSettings) {
        cancelWork()
        do {
            let next = SavedGame(settings: settings)
            let position = try Engine.query(next)
            boardID = UUID()
            game = next
            self.position = position
            selectedNode = nil
            hint = nil
            persist()
        } catch { errorMessage = error.localizedDescription }
    }
    func tap(_ node: Int) {
        guard let position, isHumanTurn, !isThinking else { return }
        hint = nil
        if let selectedNode, let action = position.legal.first(where: { $0.kind == 1 && $0.from == selectedNode && $0.to == node }) {
            apply(action)
        } else if let action = position.legal.first(where: { ($0.kind == 0 || $0.kind == 2) && $0.to == node }) {
            apply(action)
        } else if position.legal.contains(where: { $0.kind == 1 && $0.from == node }) {
            selectedNode = selectedNode == node ? nil : node
        } else { selectedNode = nil }
    }
    // A list entry already specifies the complete action; it must not toggle board selection.
    func play(_ action: EngineAction) {
        guard isHumanTurn, !isThinking else { return }
        apply(action)
    }
    private func apply(_ action: EngineAction) {
        guard var next = game, let position, position.legal.contains(action) else { return }
        next.moves.append(MoveRecord(notation: action.notation, side: position.side))
        do {
            let updated = try Engine.query(next)
            game = next
            self.position = updated
            selectedNode = nil
            hint = nil
            persist()
            resumeComputer()
        } catch { errorMessage = error.localizedDescription }
    }
    func undo() {
        guard canUndo, var next = game else { return }
        cancelWork()
        if next.settings.opponent == .computer {
            while next.moves.last?.side == 1 { next.moves.removeLast() }
            while next.moves.last?.side == 0 { next.moves.removeLast() }
        } else { next.moves.removeLast() }
        do {
            let updated = try Engine.query(next)
            game = next
            position = updated
            selectedNode = nil
            hint = nil
            persist()
        } catch { errorMessage = error.localizedDescription }
    }
    func resumeComputer() {
        guard !isThinking, let game, let position, !position.isOver,
              game.settings.opponent == .computer, position.side == 1 else { return }
        search(isHint: false)
    }
    func updateComputerSettings(_ settings: GameSettings) {
        guard var next = game, next.settings.opponent == .computer else { return }
        next.settings.level = settings.level
        next.settings.algorithm = settings.algorithm
        next.settings.effort = settings.effort
        next.settings.style = settings.style
        next.settings.openingBook = settings.openingBook
        guard next.settings != game?.settings else { return }
        do {
            let updated = try Engine.query(next)
            cancelWork()
            game = next
            position = updated
            hint = nil
            persist()
            resumeComputer()
        } catch { errorMessage = error.localizedDescription }
    }
    func requestHint() {
        guard isHumanTurn, !isThinking else { return }
        search(isHint: true)
    }
    private func search(isHint: Bool) {
        guard let game else { return }
        let cancellation: SearchCancellation
        do { cancellation = try SearchCancellation() }
        catch { errorMessage = error.localizedDescription; return }
        activeSearch = cancellation
        searchProgress.start()
        activity = isHint ? .hint : .computer
        let clock = ContinuousClock()
        let visibleAfter = clock.now.advanced(by: isHint ? .zero : pacing.minimumTime(action: position?.action ?? 0, phase: position?.phase ?? 1))
        let token = generation
        worker = Task { [weak self] in
            do {
                // Rust receives a value snapshot and never touches UI-owned state.
                let result = try await withTaskCancellationHandler {
                    try await Task.detached(priority: .userInitiated) {
                        try Engine.query(game, search: true, cancellation: cancellation)
                    }.value
                } onCancel: { cancellation.cancel() }
                guard let self, self.generation == token else { return }
                self.searchProgress.finish()
                // A monotonic, cancellable deadline: slow searches add no extra pause.
                try await clock.sleep(until: visibleAfter)
                try Task.checkCancellation()
                guard self.generation == token else { return }
                self.activity = nil
                self.activeSearch = nil
                guard let best = result.best else { throw EngineError.rejected("noBestMove") }
                if isHint {
                    self.hint = best
                    self.hintExplanation = HintExplanation(action: best, source: result.moveSource, facts: result.moveInsights ?? [])
                    self.selectedNode = best.kind == 1 ? best.from : nil
                } else { self.apply(best) }
            } catch is CancellationError {
                guard let self, self.generation == token else { return }
                self.searchProgress.finish()
                self.activity = nil
                self.activeSearch = nil
            } catch {
                guard let self, self.generation == token else { return }
                self.searchProgress.finish()
                self.activity = nil
                self.activeSearch = nil
                self.errorMessage = error.localizedDescription
            }
        }
    }
    func suspend() { cancelWork() }
    private func cancelWork() {
        searchProgress.finish()
        generation = UUID()
        activeSearch?.cancel()
        activeSearch = nil
        worker?.cancel()
        worker = nil
        activity = nil
    }
    private func persist() {
        guard usesDisk, var game else { return }
        game.updatedAt = Date()
        self.game = game
        do {
            try FileManager.default.createDirectory(at: saveURL.deletingLastPathComponent(), withIntermediateDirectories: true)
            try JSONEncoder().encode(game).write(to: saveURL, options: .atomic)
        } catch { errorMessage = L10n.text("save_error") }
    }
    // Deterministic UI-test fixture; never loaded during ordinary launches.
    func loadPreviewGame() {
        cancelWork()
        let moves = ["a7", "d7", "g7", "b6", "d6", "f6", "c5", "d5"]
        let demo = SavedGame(settings: GameSettings(opponent: .local), moves: moves.enumerated().map { MoveRecord(notation: $0.element, side: $0.offset % 2) })
        do { position = try Engine.query(demo); game = demo } catch { errorMessage = error.localizedDescription }
    }
}
