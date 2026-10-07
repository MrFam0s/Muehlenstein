// SPDX-License-Identifier: AGPL-3.0-or-later
import Foundation
import CryptoKit

/// Only the two participants' copies contain the resume key. Bonjour never advertises it.
struct LocalMatchIdentity: Codable, Equatable, Sendable {
    let id: UUID
    let side: Int
    let resumeKey: UUID

    var room: String { String(id.uuidString.prefix(6)) }
}

struct LocalMatchSnapshot: Codable, Sendable {
    let id: UUID
    let resumeKey: UUID
    let variant: Variant
    let moves: [MoveRecord]
    let fen: String

    var digest: String {
        // Fixed field order, independent of JSON dictionary ordering and device locale.
        let transcript = "\(id.uuidString)|\(variant.rawValue)|" + moves.map { "\($0.side):\($0.notation)" }.joined(separator: "|")
        return SHA256.hash(data: Data(transcript.utf8)).map { String(format: "%02x", $0) }.joined()
    }

    func validatedGame(previous: SavedGame?) throws -> (SavedGame, Position) {
        guard moves.count <= LocalMatchPacket.maximumMoves,
              moves.allSatisfy({ $0.notation.utf8.count <= 16 && (0...1).contains($0.side) }) else {
            throw LocalMatchFailure.invalidGame
        }
        if let previous {
            guard previous.network?.id == id, previous.network?.resumeKey == resumeKey,
                  previous.settings.variant == variant,
                  moves.starts(with: previous.moves) else { throw LocalMatchFailure.invalidGame }
        }
        let game = SavedGame(settings: GameSettings(variant: variant, opponent: .network), moves: moves,
                             network: LocalMatchIdentity(id: id, side: 1, resumeKey: resumeKey))
        let position = try Engine.query(game)
        guard position.fen == fen else { throw LocalMatchFailure.invalidGame }
        return (game, position)
    }
}

enum LocalMatchFailure: String, Error, Codable, Sendable {
    case incompatible, declined, invalidGame, unavailable, timeout
    var message: String { L10n.text("network_error_" + rawValue) }
}

struct LocalMatchPacket: Codable, Sendable {
    static let currentVersion = 1
    static let engine = "8901a06f088bf49a1602fee8686ed25ac5a33925"
    static let maximumBytes = 256 * 1024
    static let maximumMoves = 2048
    var version = currentVersion
    var engine = Self.engine
    let event: Event

    enum Event: Codable, Sendable {
        case join(resumeKey: UUID?)
        case state(LocalMatchSnapshot)
        case acknowledged(revision: Int, digest: String)
        case move(revision: Int, digest: String, action: EngineAction)
        case rejected(LocalMatchFailure)
        case pause
    }

    static func decode(_ data: Data) throws -> Self {
        guard data.count <= maximumBytes else { throw LocalMatchFailure.invalidGame }
        let packet = try JSONDecoder().decode(Self.self, from: data)
        guard packet.version == currentVersion, packet.engine == engine else { throw LocalMatchFailure.incompatible }
        return packet
    }
    func encoded() throws -> Data {
        let data = try JSONEncoder().encode(self)
        guard data.count <= Self.maximumBytes else { throw LocalMatchFailure.invalidGame }
        return data
    }
}
