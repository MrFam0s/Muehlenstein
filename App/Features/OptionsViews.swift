// SPDX-License-Identifier: AGPL-3.0-or-later
import SwiftUI

struct DisplayOptionsView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.dynamicTypeSize) private var dynamicType
    @Environment(AppPreferences.self) private var preferences
    @State private var showingHelp = false
    private let keys = ["show_legal", "show_last", "disable_stone_animations"]
    private var items: [String] { keys + AccentPalette.allCases.map(\.rawValue) }

    var body: some View {
        NavigationStack {
            ViewThatFits(in: .vertical) {
                VStack(spacing: 16) {
                    VStack(spacing: 8) { ForEach(keys, id: \.self) { row($0) } }
                    Divider()
                    VStack(alignment: .leading, spacing: 12) {
                        Text(L10n.text("accent_color")).font(.headline).foregroundStyle(Color.ink)
                            .accessibilityAddTraits(.isHeader)
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 8) {
                            ForEach(AccentPalette.allCases) { colorChoice($0) }
                        }
                    }
                }.padding(16).fixedSize(horizontal: false, vertical: true)
                // Keep every control reachable at large type sizes and in short landscape sheets.
                PagedRows(items: items) { _, key in
                    if let palette = AccentPalette(rawValue: key) { colorChoice(palette) }
                    else { row(key) }
                }
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
        }.presentationDetents([dynamicType.isAccessibilitySize ? .large : .height(500)])
            .presentationSizing(SettingsSheetSizing(height: dynamicType.isAccessibilitySize ? 760 : 500))
    }
    private func colorChoice(_ palette: AccentPalette) -> some View {
        let selected = preferences.accentPalette == palette
        return Button { preferences.accentPalette = palette } label: {
            HStack(spacing: 8) {
                Circle().fill(palette.color).frame(width: 26, height: 26)
                    .overlay {
                        if selected {
                            Image(systemName: "checkmark").font(.system(size: 13, weight: .bold))
                                .foregroundStyle(Color("AccentContent"))
                        }
                    }
                Text(palette.name).font(.subheadline).fixedSize(horizontal: false, vertical: true)
                Spacer(minLength: 0)
            }.padding(.horizontal, 10).frame(maxWidth: .infinity, minHeight: 44)
                .background(Color.boardSurface, in: RoundedRectangle(cornerRadius: 12))
                .overlay {
                    RoundedRectangle(cornerRadius: 12).strokeBorder(selected ? palette.color : .clear, lineWidth: 1.5)
                }
        }.buttonStyle(.plain).foregroundStyle(Color.ink)
            .accessibilityLabel(palette.name).accessibilityAddTraits(selected ? [.isSelected] : [])
            .accessibilityIdentifier("accent_" + palette.rawValue)
    }
    private func row(_ key: String) -> some View {
        @Bindable var preferences = preferences
        let value: Binding<Bool>
        switch key {
        case "show_legal": value = $preferences.showLegalMoves
        case "show_last": value = $preferences.showLastMove
        default: value = Binding(get: { !preferences.animateStones }, set: { preferences.animateStones = !$0 })
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
                .navigationTitle(L10n.text("computer_options")).navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .cancellationAction) { Button(L10n.text("cancel")) { dismiss() } }
                    ToolbarItem(placement: .confirmationAction) {
                        Button(L10n.text("done")) { apply(settings); dismiss() }.accessibilityIdentifier("computer_done")
                    }
                }
        }.presentationDetents([dynamicType.isAccessibilitySize ? .large : .height(expanded ? 530 : 300)])
            .presentationSizing(SettingsSheetSizing(height: dynamicType.isAccessibilitySize ? 760 : (expanded ? 530 : 300)))
    }
}
