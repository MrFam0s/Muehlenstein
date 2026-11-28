// SPDX-License-Identifier: AGPL-3.0-or-later
import Foundation

struct EngineAction: Codable, Equatable, Sendable {
    let kind: Int
    let from: Int
    let to: Int
    let notation: String

    func description(in position: Position) -> String {
        let target = position.nodes[to].label
        switch kind {
        case 0: return L10n.format("last_placed_at", target)
        case 1: return "\(position.nodes[from].label) → \(target)"
        default: return L10n.format("last_removed_at", target)
        }
    }
}
struct BoardNode: Codable, Identifiable, Sendable {
    let id: Int
    let label: String
    let x: Double
    let y: Double
}
struct Position: Decodable, Sendable {
    let version: Int
    let actors: [Int]
    let lastTurn: [EngineAction]
    let board: [Int]
    let hand: [Int]
    let onBoard: [Int]
    let side: Int
    let phase: Int
    let action: Int
    let outcome: String
    let winner: Int
    let reason: String
    let legal: [EngineAction]
    let nodes: [BoardNode]
    let edges: [[Int]]
    let lines: [[Int]]
    let fen: String
    let best: EngineAction?
    let searchDepth: Int
    let searchNodes: Int
    let moveSource: String?
    let moveInsights: [String]?
    var isOver: Bool { outcome != "ongoing" }

    func emptyNeighbours(of point: Int) -> Int {
        edges.filter { edge in
            edge.contains(point) && edge.contains { $0 != point && board[$0] == 0 }
        }.count
    }
}

struct HintExplanation: Sendable {
    let action: EngineAction
    let source: String?
    let facts: [String]
    var text: String {
        let supported = ["wins", "mill", "multiple_mills", "capture", "blocks_line", "builds_line"]
        let observations = facts.filter { supported.contains($0) }.map { L10n.text("hint_fact_" + $0) }
        return ([L10n.format("hint_move", action.notation)] + observations +
            [L10n.text(source == "book" ? "hint_from_book" : "hint_from_search")]).joined(separator: "\n\n")
    }
}

enum Variant: Int, Codable, CaseIterable, Identifiable, Sendable {
    case classic = 0, twelve = 1, morabaraba = 3, lasker = 5
    var id: Int { rawValue }
    var key: String {
        switch self { case .classic: "classic"; case .twelve: "twelve"; case .morabaraba: "morabaraba"; case .lasker: "lasker" }
    }
    var stones: Int { switch self { case .classic: 9; case .lasker: 10; default: 12 } }
}
enum Opponent: String, Codable, CaseIterable, Identifiable, Sendable {
    case computer, local, network
    var id: String { rawValue }
}
enum SearchAlgorithm: String, Codable, CaseIterable, Sendable {
    case mtdf, pvs
    var name: String { self == .mtdf ? "MTD(f)" : "PVS" }
}
enum SearchEffort: String, Codable, CaseIterable, Sendable {
    case standard, extended
}
enum ComputerStyle: String, Codable, CaseIterable, Sendable {
    case balanced, blocking
}
struct GameSettings: Codable, Equatable, Sendable {
    static let levels = 1...5
    static let defaultLevel = 1
    var variant: Variant = .classic
    var opponent: Opponent = .computer
    var level = GameSettings.defaultLevel
    var algorithm: SearchAlgorithm = .mtdf
    var effort: SearchEffort = .standard
    var style: ComputerStyle = .balanced
    var openingBook = true

    var adaptive = false

    enum CodingKeys: String, CodingKey { case variant, opponent, level, algorithm, effort, style, openingBook, adaptive }
}
extension GameSettings {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        variant = try values.decode(Variant.self, forKey: .variant)
        opponent = try values.decode(Opponent.self, forKey: .opponent)
        level = try values.decode(Int.self, forKey: .level)
        adaptive = try values.decodeIfPresent(Bool.self, forKey: .adaptive) ?? false
        algorithm = try values.decode(SearchAlgorithm.self, forKey: .algorithm)
        effort = try values.decode(SearchEffort.self, forKey: .effort)
        style = try values.decodeIfPresent(ComputerStyle.self, forKey: .style) ?? .balanced
        openingBook = try values.decodeIfPresent(Bool.self, forKey: .openingBook) ?? true
    }
}
struct MoveRecord: Codable, Equatable, Sendable {
    let notation: String
    let side: Int
}
struct GameHistoryEntry: Codable, Equatable, Sendable {
    enum Kind: String, Codable, Sendable { case move, hint, undo }
    var kind: Kind
    var moveNumber: Int
    var side: Int
    var notation: String = ""
    var remainingMoves: Int = 0
}
struct GameHistory: Codable, Sendable {
    var includesWholeGame = true
    var entries: [GameHistoryEntry] = []
}
/// Results are measured against the recommended level. Beating a weaker opponent
/// or losing to a harder one cannot push the recommendation in the wrong direction.
struct AdaptiveStrength: Codable, Equatable, Sendable {
    private(set) var level = GameSettings.defaultLevel
    private var previousDirection = 0

    mutating func record(winner: Int, at opponentLevel: Int) {
        let direction: Int
        switch winner {
        case 0 where opponentLevel >= level && level < GameSettings.levels.upperBound: direction = 1
        case 1 where opponentLevel <= level && level > GameSettings.levels.lowerBound: direction = -1
        default: direction = 0
        }
        if direction != 0 && direction == previousDirection {
            level += direction
            previousDirection = 0
        } else {
            previousDirection = direction
        }
    }
}

struct SavedGame: Codable, Sendable {
    var schema = 2
    var engineRevision = "8901a06f088bf49a1602fee8686ed25ac5a33925"
    var settings: GameSettings
    var moves: [MoveRecord] = []
    var updatedAt = Date()
    var network: LocalMatchIdentity?
    // Optional so published 1.3.1 saves remain readable. Unknown past aid use
    // must never be presented as proof that no assistance was used.
    var history: GameHistory?
    var dismissedResult: String?
    // This is the local baseline before this game. Replaying, undoing or reopening
    // a result never compounds it. The next save carries the updated baseline.
    var priorStrength: AdaptiveStrength?
    var playedAtMultipleLevels: Bool?

    func strengthAfterGame(at position: Position) -> AdaptiveStrength {
        var progress = priorStrength ?? AdaptiveStrength()
        guard settings.opponent == .computer, position.isOver,
              position.outcome == "win" || position.outcome == "draw",
              playedAtMultipleLevels != true, history?.includesWholeGame == true,
              !historyEntries.contains(where: { $0.kind == .hint || $0.kind == .undo }) else { return progress }
        progress.record(winner: position.winner, at: settings.level)
        return progress
    }

    var historyEntries: [GameHistoryEntry] {
        history?.entries ?? moves.enumerated().map {
            GameHistoryEntry(kind: .move, moveNumber: $0.offset + 1, side: $0.element.side, notation: $0.element.notation)
        }
    }
    mutating func record(_ entry: GameHistoryEntry) {
        if history == nil { history = GameHistory(includesWholeGame: false, entries: historyEntries) }
        history?.entries.append(entry)
    }
    var hintCount: Int { historyEntries.filter { $0.kind == .hint }.count }
    var undoCount: Int { historyEntries.filter { $0.kind == .undo }.count }
    var assistanceSummary: String {
        var lines = [L10n.format("hints_used", hintCount), L10n.format("undos_used", undoCount)]
        if history?.includesWholeGame != true { lines.append(L10n.text("assistance_past_unknown")) }
        return lines.joined(separator: "\n")
    }
    // Entries are retained when a move is undone; only the active path is marked
    // as current. This also works after replacing an undone move with another one.
    var activeHistoryMoves: Set<Int> {
        var active: [Int] = []
        for (index, entry) in historyEntries.enumerated() {
            switch entry.kind {
            case .move: active.append(index)
            case .undo: active = Array(active.prefix(max(0, entry.remainingMoves)))
            case .hint: break
            }
        }
        return Set(active)
    }
}

struct ReplayFrame: Sendable {
    let position: Position
    let moves: [MoveRecord]
    let entry: GameHistoryEntry?
    let highlight: EngineAction?

    var caption: String {
        guard let entry else { return L10n.text("replay_start") }
        switch entry.kind {
        case .hint: return L10n.format("history_hint", entry.notation)
        case .undo: return L10n.format("history_undo", entry.moveNumber, entry.remainingMoves)
        case .move:
            let side = L10n.text(entry.side == 0 ? "white" : "black")
            guard let action = highlight else { return "\(side): \(entry.notation)" }
            return "\(side): \(action.description(in: position))"
        }
    }
}

extension SavedGame {
    // Replay a journal prefix, including abandoned branches. This is a value
    // snapshot only: reviewing never invokes GameStore, AI, saving or networking.
    func replay(at step: Int) throws -> ReplayFrame {
        let entries = historyEntries
        guard (0...entries.count).contains(step) else { throw EngineError.rejected("invalidHistory") }
        var snapshot = self
        snapshot.moves = []
        for entry in entries.prefix(step) {
            switch entry.kind {
            case .move: snapshot.moves.append(MoveRecord(notation: entry.notation, side: entry.side))
            case .hint: break
            case .undo:
                guard (0...snapshot.moves.count).contains(entry.remainingMoves) else { throw EngineError.rejected("invalidHistory") }
                snapshot.moves = Array(snapshot.moves.prefix(entry.remainingMoves))
            }
        }
        let position = try Engine.query(snapshot)
        let entry = step == 0 ? nil : entries[step - 1]
        let highlight: EngineAction?
        switch entry?.kind {
        case .hint: highlight = position.legal.first { $0.notation == entry?.notation }
        case .move: highlight = position.lastTurn.last { $0.notation == entry?.notation }
        default: highlight = nil
        }
        return ReplayFrame(position: position, moves: snapshot.moves, entry: entry, highlight: highlight)
    }
}

/// A review uses the active branch as it stood just before the chosen action.
struct MoveAnalysisRequest: Sendable {
    let before: SavedGame
    let played: EngineAction

    init?(game: SavedGame, finished: Bool, frame: ReplayFrame) {
        guard finished, let entry = frame.entry, entry.kind == .move,
              let action = frame.highlight, entry.notation == action.notation,
              frame.moves.last == MoveRecord(notation: action.notation, side: entry.side) else { return nil }
        switch game.settings.opponent {
        case .computer: guard entry.side == 0 else { return nil }
        case .network: guard entry.side == game.network?.side else { return nil }
        case .local: break // Both people play on this device.
        }
        var snapshot = game
        snapshot.moves = Array(frame.moves.dropLast())
        before = snapshot
        played = action
    }

    func evaluate(cancellation: SearchCancellation) throws -> MoveAnalysis {
        let position = try Engine.query(before, search: true, isHint: true, cancellation: cancellation)
        guard position.legal.contains(played), let choice = position.best else {
            throw EngineError.rejected("analysisUnavailable")
        }
        var line = before
        line.moves.append(MoveRecord(notation: choice.notation, side: position.side))
        let facts = position.moveInsights ?? []
        let next = try Engine.query(line)
        // If no immediate feature explains a quiet move, look one turn further.
        var reply: EngineAction?
        let connections = choice.kind == 2 ? 0 : next.emptyNeighbours(of: choice.to)
        if facts.isEmpty, connections < 2, position.moveSource == "search", position.legal.count > 1, !next.isOver {
            do {
                reply = try Engine.query(line, search: true, isHint: true, cancellation: cancellation).best
            } catch is CancellationError {
                throw CancellationError()
            } catch EngineError.rejected("searchIncomplete") {
                // The main suggestion is still valid when the optional search times out.
            }
        }
        return MoveAnalysis(choice: choice, position: next, moves: line.moves, facts: facts, freeNeighbours: connections,
                            onlyMove: position.legal.count == 1, fromBook: position.moveSource == "book",
                            depth: position.searchDepth, reply: reply)
    }
}

struct MoveAnalysis: Sendable {
    let choice: EngineAction
    let position: Position // Board after the recommended action, including captures.
    let moves: [MoveRecord]
    let facts: [String]
    let freeNeighbours: Int
    let onlyMove: Bool
    let fromBook: Bool
    let depth: Int
    let reply: EngineAction?

    var explanation: String {
        var lines = facts.map { L10n.text("hint_fact_" + $0) }
        if facts.isEmpty && freeNeighbours >= 2 {
            lines.append(L10n.format("analysis_connections", position.nodes[choice.to].label, freeNeighbours))
        }
        if onlyMove { lines.insert(L10n.text("analysis_only"), at: 0) }
        else if fromBook { lines.append(L10n.text("analysis_book")) }
        else { lines.append(L10n.format("analysis_depth", depth)) }
        if let reply {
            let side = L10n.text(position.side == 0 ? "white" : "black")
            lines.append(L10n.format("analysis_reply", side, reply.description(in: position)))
        }
        return lines.joined(separator: "\n\n")
    }
}

enum EngineError: LocalizedError {
    case rejected(String)
    var errorDescription: String? { L10n.text("engine_error") }
}
// The immutable ID refers to an Arc<AtomicBool> in a mutex-protected Rust registry.
// Every C entry point is thread safe; no Swift mutable state crosses threads.
final class SearchCancellation: @unchecked Sendable {
    let id: UInt64
    init() throws {
        id = ms_search_create()
        guard id != 0 else { throw EngineError.rejected("searchTokenUnavailable") }
    }
    func cancel() { ms_search_cancel(id) }
    deinit { ms_search_release(id) }
}

enum Engine {
    private struct Request: Encodable {
        let version = 1
        let preset: Int
        let moves: [String]
        let search: Bool
        let level: Int
        let level_scale = "five"
        let algorithm: SearchAlgorithm
        let effort: SearchEffort
        let style: ComputerStyle
        let opening_book: Bool
        let search_id: UInt64?
        let purpose: String
        let varied_play: Bool
    }
    static func query(_ game: SavedGame, search: Bool = false, isHint: Bool = false, cancellation: SearchCancellation? = nil) throws -> Position {
        let data = try JSONEncoder().encode(Request(preset: game.settings.variant.rawValue,
            moves: game.moves.map(\.notation), search: search, level: game.settings.level,
            algorithm: game.settings.algorithm, effort: game.settings.effort, style: game.settings.style,
            opening_book: game.settings.openingBook,
            search_id: cancellation?.id, purpose: isHint ? "hint" : "opponent",
            varied_play: !isHint))
        let input = String(decoding: data, as: UTF8.self)
        let output = withExtendedLifetime(cancellation) {
            input.withCString { ms_request($0) }
        }
        guard let output else { throw EngineError.rejected("noResponse") }
        defer { ms_string_free(output) }
        let response = Data(String(cString: output).utf8)
        if let error = try JSONSerialization.jsonObject(with: response) as? [String: String], let code = error["error"] {
            if code == "cancelled" { throw CancellationError() }
            throw EngineError.rejected(code)
        }
        let position = try JSONDecoder().decode(Position.self, from: response)
        guard position.actors == game.moves.map(\.side) else { throw EngineError.rejected("invalidActors") }
        return position
    }
}

enum L10n {
    static func text(_ key: String) -> String { Bundle.main.localizedString(forKey: key, value: key, table: nil) }
    static func moveCount(_ count: Int) -> String { format(count == 1 ? "move_count_one" : "move_count", count) }
    static func format(_ key: String, _ arguments: CVarArg...) -> String {
        String(format: text(key), locale: Locale.current, arguments: arguments)
    }
}
