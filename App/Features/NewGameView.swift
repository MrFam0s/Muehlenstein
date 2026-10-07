// SPDX-License-Identifier: AGPL-3.0-or-later
import SwiftUI

struct NewGameView: View {
    @Environment(\.accentPalette) private var palette
    @Environment(\.dismiss) private var dismiss
    @Environment(\.dynamicTypeSize) private var dynamicType
    @Environment(AppPreferences.self) private var preferences
    let hasOngoingGame: Bool
    let start: (GameSettings) -> Void
    let startNetwork: (LocalMatchSession) -> Void
    @State private var network = LocalMatchSession()
    @State private var showingNetwork = false
    @State private var adoptedNetwork = false
    @State private var settings: GameSettings
    @State private var confirmsReplacement = false
    @State private var expanded = false

    init(hasOngoingGame: Bool, initialLevel: Int, startNetwork: @escaping (LocalMatchSession) -> Void, start: @escaping (GameSettings) -> Void) {
        self.hasOngoingGame = hasOngoingGame
        self.start = start
        self.startNetwork = startNetwork
        _settings = State(initialValue: GameSettings(level: initialLevel))
    }
    private var sheetHeight: CGFloat {
        if dynamicType.isAccessibilitySize { return 760 }
        if showingNetwork { return network.phase == .awaitingApproval ? 380 : 440 }
        if settings.opponent != .computer { return 400 }
        return expanded ? 750 : 540
    }

    var body: some View {
        NavigationStack {
            VStack(spacing: 12) {
                if showingNetwork {
                    NetworkLobbyView(session: network, variant: settings.variant).frame(maxHeight: .infinity)
                } else {
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
                            Text(L10n.text(confirmsReplacement ? "replace_ongoing_game" : settings.opponent == .network ? "network_continue" : "start_game"))
                        }.font(.headline).multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true).frame(maxWidth: .infinity)
                            .padding(.vertical, 12).foregroundStyle(Color("AccentContent"))
                            .background(palette.color, in: RoundedRectangle(cornerRadius: 16))
                    }.buttonStyle(.plain).accessibilityIdentifier("start_game")
                }
            }.padding(16).frame(maxWidth: 760).frame(maxWidth: .infinity)
                .background(Color.limestone)
                .navigationTitle(L10n.text("new_game")).navigationBarTitleDisplayMode(.inline)
                .toolbar { ToolbarItem(placement: .cancellationAction) { Button(L10n.text("cancel")) { dismiss() }.tint(.ink) } }
        }
        .onChange(of: network.hasStarted) { _, started in
            if started && !adoptedNetwork {
                adoptedNetwork = true
                startNetwork(network)
                dismiss()
            }
        }
        .onDisappear { if !adoptedNetwork { network.stop() } }
        .onChange(of: settings) { _, _ in confirmsReplacement = false }
        .onChange(of: hasOngoingGame) { _, _ in confirmsReplacement = false }
        .presentationDetents([dynamicType.isAccessibilitySize ? .large : .height(sheetHeight)])
        .presentationSizing(SettingsSheetSizing(height: sheetHeight))
    }
    private func begin() {
        if settings.opponent == .network { showingNetwork = true; return }
        if settings.opponent == .computer { preferences.lastComputerLevel = settings.level }
        start(settings)
        dismiss()
    }
}
