// SPDX-License-Identifier: AGPL-3.0-or-later
import SwiftUI

struct BoardView: View {
    let position: Position
    var selected: Int? = nil
    var hint: EngineAction? = nil
    var recentActions: [EngineAction] = []
    var showLegalMoves = true
    var interactive = true
    var tap: (Int) -> Void = { _ in }

    private func coordinate(_ value: Double, size: CGFloat) -> CGFloat {
        // Preserve node identity; spread nested squares evenly for finger targets.
        let distance = abs(value - 0.5)
        let remapped = distance < 0.01 ? 0 : 0.15 + (distance - 0.2) * 1.4
        return size * (0.5 + (value < 0.5 ? -remapped : remapped))
    }
    private func point(_ node: Int, size: CGFloat) -> CGPoint {
        let n = position.nodes[node]
        return CGPoint(x: coordinate(n.x, size: size), y: coordinate(n.y, size: size))
    }
    private func destination(_ node: Int) -> Bool {
        guard interactive, showLegalMoves else { return false }
        return position.legal.contains { a in
            if a.kind == 0 || a.kind == 2 { return a.to == node }
            return selected != nil && a.kind == 1 && a.from == selected && a.to == node
        }
    }
    private func recentValue(_ node: Int) -> String {
        if recentActions.contains(where: { $0.kind == 2 && $0.to == node }) { return L10n.text("last_captured") }
        if recentActions.contains(where: { $0.kind == 1 && $0.from == node }) { return L10n.text("last_origin") }
        if recentActions.contains(where: { $0.kind != 2 && $0.to == node }) { return L10n.text("last_destination") }
        return ""
    }
    private func accessibilityValue(_ node: Int) -> String {
        [selected == node ? L10n.text("selected") : "", destination(node) ? L10n.text("legal_target") : "", recentValue(node)]
            .filter { !$0.isEmpty }.joined(separator: ", ")
    }
    var body: some View {
        GeometryReader { geo in
            let size = geo.size.width
            ZStack {
                RoundedRectangle(cornerRadius: 26).fill(Color.boardSurface)
                Path { path in
                    for edge in position.edges {
                        path.move(to: point(edge[0], size: size))
                        path.addLine(to: point(edge[1], size: size))
                    }
                }.stroke(Color.boardLine, style: StrokeStyle(lineWidth: 1.5, lineCap: .round))
                Path { path in
                    for action in recentActions where action.kind == 1 {
                        path.move(to: point(action.from, size: size))
                        path.addLine(to: point(action.to, size: size))
                    }
                }.stroke(Color.petrol.opacity(0.65), style: StrokeStyle(lineWidth: 2, dash: [4, 5]))
                    .allowsHitTesting(false).accessibilityHidden(true)
                ForEach(position.nodes) { node in
                    let stone = position.board[node.id]
                    Button { tap(node.id) } label: {
                        ZStack {
                            if stone > 0 {
                                Stone(side: stone - 1, selected: selected == node.id, size: min(32, size * 0.09))
                            } else {
                                Circle().fill(Color.boardLine).frame(width: 5, height: 5)
                            }
                            if recentActions.contains(where: { $0.kind != 2 && $0.to == node.id }) {
                                Circle().strokeBorder(Color.petrol.opacity(0.75), lineWidth: 1.5).frame(width: 43, height: 43)
                            }
                            if recentActions.contains(where: { $0.kind == 1 && $0.from == node.id }) {
                                Circle().strokeBorder(Color.petrol, style: StrokeStyle(lineWidth: 1.5, dash: [2, 3])).frame(width: 23, height: 23)
                            }
                            if recentActions.contains(where: { $0.kind == 2 && $0.to == node.id }) {
                                Circle().fill(Color.boardSurface).frame(width: 23, height: 23)
                                Image(systemName: "xmark").font(.system(size: 12, weight: .medium)).foregroundStyle(Color.petrol)
                            }
                            if destination(node.id), stone == 0, selected == nil, hint?.to != node.id {
                                Circle().fill(Color.petrol).frame(width: 9, height: 9)
                            } else if destination(node.id) || hint?.to == node.id {
                                Circle().strokeBorder(Color.petrol, style: StrokeStyle(lineWidth: 2, dash: stone > 0 ? [3, 3] : []))
                                    .frame(width: 22, height: 22)
                            }
                        }.frame(width: 44, height: 44).contentShape(Circle())
                    }
                    .buttonStyle(BoardPointStyle())
                    .disabled(!interactive || position.isOver)
                    .accessibilityLabel("\(node.label), \(L10n.text(stone == 0 ? "empty" : stone == 1 ? "white" : "black"))")
                    .accessibilityValue(accessibilityValue(node.id))
                    .accessibilityIdentifier("node_\(node.label)")
                    .position(point(node.id, size: size))
                }
            }
        }.aspectRatio(1, contentMode: .fit)
    }
}

// Keep stone materials opaque when interaction is disabled (AI turn / illustration).
private struct BoardPointStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View { configuration.label }
}
