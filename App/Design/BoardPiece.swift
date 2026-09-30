// SPDX-License-Identifier: AGPL-3.0-or-later
import Foundation

/// A visual identity follows the original placement through moves and undo.
/// The engine's board remains authoritative; this only reconstructs drawing identities.
struct BoardPiece: Identifiable, Equatable {
    let id: Int
    let side: Int
    var node: Int

    static func layout(position: Position, moves: [MoveRecord]?) -> [BoardPiece] {
        if let moves, let pieces = tracked(position: position, moves: moves) { return pieces }
        // Static illustrations and any future unsupported transcript still show the exact board.
        return position.board.enumerated().compactMap { node, value in
            value > 0 ? BoardPiece(id: -node - 1, side: value - 1, node: node) : nil
        }
    }

    static func tracked(position: Position, moves: [MoveRecord]) -> [BoardPiece]? {
        let nodes = Dictionary(uniqueKeysWithValues: position.nodes.map { ($0.label, $0.id) })
        var pieces: [Int: BoardPiece] = [:]
        for (index, move) in moves.enumerated() {
            guard (0...1).contains(move.side) else { return nil }
            if move.notation.hasPrefix("x") {
                guard let node = nodes[String(move.notation.dropFirst())],
                      let captured = pieces.removeValue(forKey: node), captured.side != move.side else { return nil }
            } else {
                let ends = move.notation.split(separator: "-")
                if ends.count == 2 {
                    guard let from = nodes[String(ends[0])], let to = nodes[String(ends[1])],
                          var piece = pieces.removeValue(forKey: from), piece.side == move.side,
                          pieces[to] == nil else { return nil }
                    piece.node = to
                    pieces[to] = piece
                } else {
                    guard let node = nodes[move.notation], pieces[node] == nil else { return nil }
                    pieces[node] = BoardPiece(id: index, side: move.side, node: node)
                }
            }
        }
        guard position.board.enumerated().allSatisfy({ node, value in
            (pieces[node].map { $0.side + 1 } ?? 0) == value
        }) else { return nil }
        return pieces.values.sorted { $0.id < $1.id }
    }
}
