// SPDX-License-Identifier: AGPL-3.0-or-later
import SwiftUI

struct DisplayOptionsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.dynamicTypeSize) private var dynamicType
    @Environment(AppPreferences.self) private var preferences
    @State private var showingHelp = false
    private let keys = ["show_legal", "show_last", "show_level", "animate_stones"]

    var body: some View {
        NavigationStack {
            ViewThatFits(in: .vertical) {
                VStack(spacing: 8) { ForEach(keys, id: \.self) { row($0) } }
                    .padding(16).fixedSize(horizontal: false, vertical: true)
                PagedRows(items: keys) { _, key in row(key) }
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
                .background(Color.limestone)
                .navigationTitle(L10n.text("display_options")).navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .confirmationAction) {
                        Button(L10n.text("done")) { dismiss() }.accessibilityIdentifier("display_done")
                    }
                }
                .sheet(isPresented: $showingHelp) {
                    ReadingSheet(title: L10n.text("display_help"), text: L10n.text("display_help_body"))
                }
        }.presentationDetents([dynamicType.isAccessibilitySize ? .large : .height(340)])
            .presentationSizing(SettingsSheetSizing(height: dynamicType.isAccessibilitySize ? 760 : 340))
    }
    private func row(_ key: String) -> some View {
        @Bindable var preferences = preferences
        let value: Binding<Bool>
        switch key {
        case "show_legal": value = $preferences.showLegalMoves
        case "show_last": value = $preferences.showLastMove
        case "show_level": value = $preferences.showLevel
        default: value = $preferences.animateStones
        }
        return HStack(spacing: 8) {
            Toggle(L10n.text(key), isOn: value).accessibilityIdentifier(key)
            Button { showingHelp = true } label: { Image(systemName: "info.circle").font(.system(size: 22)).frame(width: 44, height: 44) }
                .accessibilityLabel(L10n.text("display_help")).accessibilityIdentifier("info_" + key)
        }.frame(minHeight: 44)
    }
}

struct ComputerOptionsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.dynamicTypeSize) private var dynamicType
    @State private var settings: GameSettings
    @State private var expanded = false
    let apply: (GameSettings) -> Void

    init(settings: GameSettings, apply: @escaping (GameSettings) -> Void) {
        _settings = State(initialValue: settings)
        self.apply = apply
    }
    var body: some View {
        NavigationStack {
            GameSetupEditor(settings: $settings, expanded: $expanded, includesGame: false)
                .padding(16).background(Color.limestone)
                .navigationTitle(L10n.text("computer")).navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) { Button(L10n.text("cancel")) { dismiss() } }
                    ToolbarItem(placement: .confirmationAction) {
                        Button(L10n.text("done")) { apply(settings); dismiss() }.accessibilityIdentifier("computer_done")
                    }
                }
        }.presentationDetents([dynamicType.isAccessibilitySize ? .large : .height(expanded ? 410 : 300)])
            .presentationSizing(SettingsSheetSizing(height: dynamicType.isAccessibilitySize ? 760 : (expanded ? 410 : 300)))
    }
}
