// SPDX-License-Identifier: AGPL-3.0-or-later
import SwiftUI

struct NewGameView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.dynamicTypeSize) private var dynamicType
    let hasOngoingGame: Bool
    let start: (GameSettings) -> Void
    @State private var settings = GameSettings()
    @State private var confirm = false
    @State private var expanded = false
    private var sheetHeight: CGFloat {
        if dynamicType.isAccessibilitySize { return 760 }
        if settings.opponent == .local { return 400 }
        return expanded ? 700 : 540
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                GameSetupEditor(settings: $settings, expanded: $expanded)
                Button {
                    if hasOngoingGame { confirm = true } else { begin() }
                } label: {
                    Text(L10n.text("start_game")).font(.headline).frame(maxWidth: .infinity)
                        .padding(.vertical, 12).foregroundStyle(Color("AccentContent"))
                        .background(Color.petrol, in: RoundedRectangle(cornerRadius: 16))
                }.buttonStyle(.plain).accessibilityIdentifier("start_game")
            }.padding(16).frame(maxWidth: 760).frame(maxWidth: .infinity)
                .background(Color.limestone)
                .navigationTitle(L10n.text("new_game")).navigationBarTitleDisplayMode(.inline)
                .toolbar { ToolbarItem(placement: .cancellationAction) { Button(L10n.text("cancel")) { dismiss() }.tint(.ink) } }
                .confirmationDialog(L10n.text("replace_game"), isPresented: $confirm, titleVisibility: .visible) {
                    Button(L10n.text("replace_and_start"), role: .destructive) { begin() }
                    Button(L10n.text("cancel"), role: .cancel) { }
                }
        }
        .presentationDetents([dynamicType.isAccessibilitySize ? .large : .height(sheetHeight)])
        .presentationSizing(SettingsSheetSizing(height: sheetHeight))
    }
    private func begin() { start(settings); dismiss() }
}
