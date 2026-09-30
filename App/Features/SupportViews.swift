// SPDX-License-Identifier: AGPL-3.0-or-later
import SwiftUI

struct HistoryView: View {
    @Environment(\.dismiss) private var dismiss
    let game: SavedGame?
    var body: some View {
        NavigationStack {
            Group {
                if let game, !game.moves.isEmpty {
                    PagedRows(items: game.moves) { index, move in
                        HStack(spacing: 14) {
                            Text("\(index + 1)").font(.caption).monospacedDigit().foregroundStyle(Color.quietInk).frame(minWidth: 28)
                            Stone(side: move.side, size: 18)
                            Text(move.notation).font(.system(.body, design: .monospaced))
                            Spacer(minLength: 0)
                        }.accessibilityElement(children: .contain)
                            .accessibilityLabel(L10n.text(move.side == 0 ? "white" : "black"))
                    }
                } else { ContentUnavailableView(L10n.text("no_moves"), systemImage: "list.bullet") }
            }.background(Color.limestone)
                .navigationTitle(L10n.text("history")).navigationBarTitleDisplayMode(.inline)
                .toolbar { ToolbarItem(placement: .confirmationAction) { Button(L10n.text("done")) { dismiss() } } }
        }.presentationDetents([.large])
    }
}
struct LegalMovesView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable var store: GameStore
    var body: some View {
        NavigationStack {
            PagedRows(items: store.position?.legal ?? []) { _, action in
                Button(action.notation) {
                    store.play(action)
                    dismiss()
                }.frame(maxWidth: .infinity, alignment: .leading).frame(minHeight: 44)
                    .disabled(!store.isHumanTurn || store.isThinking)
            }.navigationTitle(L10n.text("legal_moves")).navigationBarTitleDisplayMode(.inline)
                .toolbar { ToolbarItem(placement: .confirmationAction) { Button(L10n.text("done")) { dismiss() } } }
        }.presentationDetents([.large])
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
