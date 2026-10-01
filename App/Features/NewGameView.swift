// SPDX-License-Identifier: AGPL-3.0-or-later
import SwiftUI

struct NewGameView: View {
    @Environment(\.accentPalette) private var palette
    @Environment(\.dismiss) private var dismiss
    @Environment(\.dynamicTypeSize) private var dynamicType
    let hasOngoingGame: Bool
    let start: (GameSettings) -> Void
    @State private var settings = GameSettings()
    @State private var confirmsReplacement = false
    @State private var expanded = false
    private var sheetHeight: CGFloat {
        if dynamicType.isAccessibilitySize { return 760 }
        if settings.opponent == .local { return 400 }
        return expanded ? 750 : 540
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                GameSetupEditor(settings: $settings, expanded: $expanded)
                Button {
                    if hasOngoingGame && !confirmsReplacement { confirmsReplacement = true }
                    else { begin() }
                } label: {
                    ZStack {
                        // Reserve both labels so confirmation never moves the button or setup controls.
                        if hasOngoingGame {
                            Text(L10n.text("replace_ongoing_game")).hidden().accessibilityHidden(true)
                        }
                        Text(L10n.text(confirmsReplacement ? "replace_ongoing_game" : "start_game"))
                    }.font(.headline).multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity)
                        .padding(.vertical, 12).foregroundStyle(Color("AccentContent"))
                        .background(palette.color, in: RoundedRectangle(cornerRadius: 16))
                }.buttonStyle(.plain).accessibilityIdentifier("start_game")
            }.padding(16).frame(maxWidth: 760).frame(maxWidth: .infinity)
                .background(Color.limestone)
                .navigationTitle(L10n.text("new_game")).navigationBarTitleDisplayMode(.inline)
                .toolbar { ToolbarItem(placement: .cancellationAction) { Button(L10n.text("cancel")) { dismiss() }.tint(.ink) } }
        }
        .onChange(of: settings) { _, _ in confirmsReplacement = false }
        .onChange(of: hasOngoingGame) { _, _ in confirmsReplacement = false }
        .presentationDetents([dynamicType.isAccessibilitySize ? .large : .height(sheetHeight)])
        .presentationSizing(SettingsSheetSizing(height: sheetHeight))
    }
    private func begin() { start(settings); dismiss() }
}
