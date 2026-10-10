// SPDX-License-Identifier: AGPL-3.0-or-later
import SwiftUI

struct HistoryView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.dynamicTypeSize) private var dynamicType
    let game: SavedGame?
    let position: Position?
    @State private var showsDetails = false
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker(L10n.text("history"), selection: $showsDetails) {
                    Text(L10n.text("history_moves")).tag(false)
                    Text(L10n.text("game_details")).tag(true)
                }.pickerStyle(.segmented).padding(.horizontal, 16).padding(.top, 8)
                    .accessibilityIdentifier("history_section")
                if showsDetails { PagedReadingView(text: details) }
                else if let game, !game.historyEntries.isEmpty {
                    let active = game.activeHistoryMoves
                    PagedGrid(items: game.historyEntries) { index, entry in
                        HStack(spacing: 6) {
                            if entry.kind == .move {
                                Text("\(entry.moveNumber)").font(.caption2).monospacedDigit().foregroundStyle(Color.quietInk)
                                Stone(side: entry.side, size: 14)
                                Text(entry.notation).font(.system(.body, design: .monospaced))
                                    .strikethrough(!active.contains(index))
                                    .foregroundStyle(active.contains(index) ? Color.ink : Color.quietInk)
                            } else {
                                Image(systemName: entry.kind == .hint ? "lightbulb" : "arrow.uturn.backward")
                                Text(entry.kind == .hint ? L10n.format("history_hint", entry.notation) : L10n.format("history_undo", entry.moveNumber, entry.remainingMoves))
                                    .font(.caption).lineLimit(2)
                            }
                            Spacer(minLength: 0)
                        }.padding(.horizontal, 8).frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.boardSurface, in: RoundedRectangle(cornerRadius: 10))
                            .accessibilityElement(children: .contain)
                            .accessibilityLabel(historyLabel(entry, undone: entry.kind == .move && !active.contains(index)))
                            .accessibilityIdentifier("history_\(entry.kind.rawValue)_\(index)")
                    }
                } else { ContentUnavailableView(L10n.text("no_moves"), systemImage: "list.bullet") }
            }.background(Color.limestone)
                .navigationTitle(L10n.text("history")).navigationBarTitleDisplayMode(.inline)
                .toolbar { ToolbarItem(placement: .confirmationAction) { Button(L10n.text("done")) { dismiss() } } }
        }.presentationDetents(dynamicType.isAccessibilitySize ? [.large] : [.height(500), .large])
            .presentationSizing(SettingsSheetSizing(height: dynamicType.isAccessibilitySize ? 760 : 500))
    }
    private func historyLabel(_ entry: GameHistoryEntry, undone: Bool) -> String {
        switch entry.kind {
        case .move:
            return "\(entry.moveNumber), \(L10n.text(entry.side == 0 ? "white" : "black")), \(entry.notation)" + (undone ? ", " + L10n.text("move_undone") : "")
        case .hint: return L10n.format("history_hint", entry.notation)
        case .undo: return L10n.format("history_undo", entry.moveNumber, entry.remainingMoves)
        }
    }
    private var details: String {
        guard let game, let position else { return L10n.text("no_moves") }
        let outcome = position.isOver
            ? (position.outcome == "draw" ? L10n.text("draw") : L10n.format("wins", L10n.text(position.winner == 0 ? "white" : "black")))
            : L10n.format("side_to_move", L10n.text(position.side == 0 ? "white" : "black"))
        var lines = [L10n.text(game.settings.variant.key), outcome]
        if game.settings.opponent != .network { lines.append(game.assistanceSummary) }
        lines += [
            L10n.text(position.isOver ? "finished" : position.action == 2 ? "capture_phase" : position.phase == 2 ? "moving_phase" : "placing_phase"),
            L10n.moveCount(game.moves.count),
            L10n.format("side_counts", L10n.text("white"), position.onBoard[0], position.hand[0]),
            L10n.format("side_counts", L10n.text("black"), position.onBoard[1], position.hand[1])]
        if game.settings.opponent == .computer {
            lines += [L10n.format("computer_configuration", game.settings.level, L10n.text("level_\(game.settings.level)")),
                L10n.text("computer_style") + ": " + L10n.text("style_" + game.settings.style.rawValue),
                game.settings.algorithm.name + " · " + L10n.text("effort_" + game.settings.effort.rawValue),
                L10n.text("opening_book") + ": " + L10n.text(game.settings.openingBook ? "book_automatic" : "book_off")]
        } else { lines.append(L10n.text(game.settings.opponent.rawValue)) }
        return lines.joined(separator: "\n\n")
    }
}
struct LegalMovesView: View {
    @Environment(\.accentPalette) private var palette
    @Environment(\.dismiss) private var dismiss
    @Environment(\.dynamicTypeSize) private var dynamicType
    @Bindable var store: GameStore
    var body: some View {
        NavigationStack {
            PagedGrid(items: store.position?.legal ?? [], minimumCellWidth: 78, maximumColumns: 4) { _, action in
                Button {
                    store.play(action)
                    dismiss()
                } label: {
                    Text(action.notation).font(.system(.body, design: .monospaced)).lineLimit(1)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.boardSurface, in: RoundedRectangle(cornerRadius: 12))
                }.buttonStyle(.plain).foregroundStyle(palette.color)
                    .accessibilityIdentifier("legal_action_" + action.notation)
                    .disabled(!store.isHumanTurn || store.isThinking)
            }.navigationTitle(L10n.text("legal_moves")).navigationBarTitleDisplayMode(.inline)
                .toolbar { ToolbarItem(placement: .confirmationAction) { Button(L10n.text("done")) { dismiss() } } }
        }.presentationDetents(dynamicType.isAccessibilitySize ? [.large] : [.height(430), .large])
            .presentationSizing(SettingsSheetSizing(height: dynamicType.isAccessibilitySize ? 760 : 430))
    }
}
struct RulesView: View {
    let variant: Variant
    var body: some View {
        ReadingSheet(title: L10n.text("rules"), text:
            [("aim", "aim_body"), ("placing_phase", "placing_body"), ("moving_phase", "moving_body"),
             ("capture_phase", "capture_body"), (variant.key, variant.key + "_rules"), ("ending", "ending_body")]
                .map { L10n.text($0.0) + "\n" + L10n.text($0.1) }.joined(separator: "\n\n"))
    }
}
