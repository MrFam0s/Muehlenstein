// SPDX-License-Identifier: AGPL-3.0-or-later
import Foundation

struct EngineAction: Codable, Equatable, Sendable {
    let kind: Int
    let from: Int
    let to: Int
    let notation: String
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
    var isOver: Bool { outcome != "ongoing" }
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
    case computer, local
    var id: String { rawValue }
}
enum SearchAlgorithm: String, Codable, CaseIterable, Sendable {
    case mtdf, pvs
    var name: String { self == .mtdf ? "MTD(f)" : "PVS" }
}
enum SearchEffort: String, Codable, CaseIterable, Sendable {
    case standard, extended
}
struct GameSettings: Codable, Equatable, Sendable {
    static let levels = 1...5
    var variant: Variant = .classic
    var opponent: Opponent = .computer
    var level = 3
    var algorithm: SearchAlgorithm = .mtdf
    var effort: SearchEffort = .standard
}
struct MoveRecord: Codable, Equatable, Sendable {
    let notation: String
    let side: Int
}
struct SavedGame: Codable, Sendable {
    var schema = 2
    var engineRevision = "8901a06f088bf49a1602fee8686ed25ac5a33925"
    var settings: GameSettings
    var moves: [MoveRecord] = []
    var updatedAt = Date()
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
        let search_id: UInt64?
    }
    static func query(_ game: SavedGame, search: Bool = false, cancellation: SearchCancellation? = nil) throws -> Position {
        let data = try JSONEncoder().encode(Request(preset: game.settings.variant.rawValue,
            moves: game.moves.map(\.notation), search: search, level: game.settings.level,
            algorithm: game.settings.algorithm, effort: game.settings.effort, search_id: cancellation?.id))
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
    static func format(_ key: String, _ arguments: CVarArg...) -> String {
        String(format: text(key), locale: Locale.current, arguments: arguments)
    }
}
