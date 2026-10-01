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
                else if let game, !game.moves.isEmpty {
                    PagedGrid(items: game.moves) { index, move in
                        HStack(spacing: 6) {
                            Text("\(index + 1)").font(.caption2).monospacedDigit().foregroundStyle(Color.quietInk)
                            Stone(side: move.side, size: 14)
                            Text(move.notation).font(.system(.body, design: .monospaced))
                            Spacer(minLength: 0)
                        }.padding(.horizontal, 8).frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.boardSurface, in: RoundedRectangle(cornerRadius: 10))
                            .accessibilityElement(children: .contain)
                            .accessibilityLabel(L10n.text(move.side == 0 ? "white" : "black"))
                            .accessibilityIdentifier("history_move_\(index)")
                    }
                } else { ContentUnavailableView(L10n.text("no_moves"), systemImage: "list.bullet") }
            }.background(Color.limestone)
                .navigationTitle(L10n.text("history")).navigationBarTitleDisplayMode(.inline)
                .toolbar { ToolbarItem(placement: .confirmationAction) { Button(L10n.text("done")) { dismiss() } } }
        }.presentationDetents(dynamicType.isAccessibilitySize ? [.large] : [.height(500), .large])
            .presentationSizing(SettingsSheetSizing(height: dynamicType.isAccessibilitySize ? 760 : 500))
    }
    private var details: String {
        guard let game, let position else { return L10n.text("no_moves") }
        let outcome = position.isOver
            ? (position.outcome == "draw" ? L10n.text("draw") : L10n.format("wins", L10n.text(position.winner == 0 ? "white" : "black")))
            : L10n.format("side_to_move", L10n.text(position.side == 0 ? "white" : "black"))
        var lines = [L10n.text(game.settings.variant.key), outcome,
            L10n.text(position.isOver ? "finished" : position.action == 2 ? "capture_phase" : position.phase == 2 ? "moving_phase" : "placing_phase"),
            L10n.moveCount(game.moves.count),
            L10n.format("side_counts", L10n.text("white"), position.onBoard[0], position.hand[0]),
            L10n.format("side_counts", L10n.text("black"), position.onBoard[1], position.hand[1])]
        if game.settings.opponent == .computer {
            lines += [L10n.format("computer_configuration", game.settings.level, L10n.text("level_\(game.settings.level)")),
                L10n.text("computer_style") + ": " + L10n.text("style_" + game.settings.style.rawValue),
                game.settings.algorithm.name + " · " + L10n.text("effort_" + game.settings.effort.rawValue),
                L10n.text("opening_book") + ": " + L10n.text(game.settings.openingBook ? "book_automatic" : "book_off")]
        } else { lines.append(L10n.text("local")) }
        return lines.joined(separator: "\n\n")
    }
}
struct LegalMovesView: View {
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
                }.buttonStyle(.plain).foregroundStyle(Color.petrol)
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
struct AboutView: View {
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        NavigationStack {
            PagedRows(items: ["privacy", "credits", "license"]) { _, section in
                Group {
                    switch section {
                    case "privacy":
                        NavigationLink { PagedReadingView(text: L10n.text("privacy_body")).navigationTitle(L10n.text("privacy")) }
                            label: { Label(L10n.text("privacy"), systemImage: "hand.raised") }
                    case "credits":
                        NavigationLink {
                            PagedReadingView(text: "0.1 · " + L10n.text("prototype") + "\n\n" + L10n.text("about_body") + "\n\n" + L10n.text("credits_body"))
                                .navigationTitle(L10n.text("credits"))
                                .toolbar { ToolbarItem(placement: .bottomBar) {
                                    Link("Sanmill · GitHub", destination: URL(string: "https://github.com/calcitem/Sanmill/tree/8901a06f088bf49a1602fee8686ed25ac5a33925")!)
                                } }
                        } label: { Label(L10n.text("credits"), systemImage: "info.circle") }
                    default:
                        NavigationLink { LicenseView() } label: { Label("GNU AGPL v3", systemImage: "doc.text") }
                            .accessibilityIdentifier("license")
                    }
                }.frame(maxWidth: .infinity, alignment: .leading).font(.body)
            }
                .navigationTitle(L10n.text("about")).navigationBarTitleDisplayMode(.inline)
                .toolbar { ToolbarItem(placement: .confirmationAction) { Button(L10n.text("done")) { dismiss() } } }
        }.presentationDetents([.large])
    }
}
struct LicenseView: View {
    var body: some View {
        PagedReadingView(text: contents).navigationTitle("GNU AGPL v3").navigationBarTitleDisplayMode(.inline)
    }
    private var contents: String {
        guard let url = Bundle.main.url(forResource: "AGPL-3.0", withExtension: "txt"),
              let content = try? String(contentsOf: url, encoding: .utf8) else { return L10n.text("license_error") }
        return content
    }
}
