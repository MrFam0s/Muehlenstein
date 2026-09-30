// SPDX-License-Identifier: AGPL-3.0-or-later
import SwiftUI

struct HomeView: View {
    @Bindable var store: GameStore
    @Environment(\.dynamicTypeSize) private var dynamicType
    @Environment(\.verticalSizeClass) private var verticalSize
    @State private var showingNewGame = false
    @State private var showingAbout = false
    @State private var showingRules = false
    @State private var showingOptions = false
    @State private var path: [String] = []
    @State private var preview: Position?

    var body: some View {
        NavigationStack(path: $path) {
            GeometryReader { geometry in
                let horizontal = geometry.size.width > geometry.size.height
                Group {
                    if horizontal && dynamicType.isAccessibilitySize {
                        actions(horizontal: true)
                    } else if horizontal {
                        HStack(spacing: 24) {
                            illustration
                            VStack(spacing: 20) { heading; Spacer(minLength: 0); actions() }
                                .frame(maxWidth: 420)
                        }
                    } else {
                        VStack(spacing: 20) { heading; illustration; actions() }
                    }
                }
                .padding(20).frame(maxWidth: 900).frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .background(Color.limestone)
            .navigationTitle(verticalSize == .compact && dynamicType.isAccessibilitySize ? L10n.text("app_name") : "")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button { showingOptions = true } label: { Image(systemName: "gearshape") }
                        .accessibilityLabel(L10n.text("display_options")).accessibilityIdentifier("display_options")
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showingAbout = true } label: { Image(systemName: "info.circle") }
                        .accessibilityLabel(L10n.text("about")).accessibilityIdentifier("about")
                }
            }
            .navigationDestination(for: String.self) { _ in GameView(store: store) }
            .sheet(isPresented: $showingNewGame) {
                NewGameView(hasCurrentGame: store.game != nil) { settings in
                    store.start(settings)
                    if store.position != nil { path = ["game"] }
                }
            }
            .sheet(isPresented: $showingAbout) { AboutView() }
            .sheet(isPresented: $showingRules) { RulesView(variant: .classic) }
            .sheet(isPresented: $showingOptions) { DisplayOptionsView() }
            .alert(L10n.text("notice"), isPresented: Binding(get: { store.errorMessage != nil }, set: { if !$0 { store.errorMessage = nil } })) {
                Button(L10n.text("ok"), role: .cancel) { store.errorMessage = nil }
            } message: { Text(store.errorMessage ?? "") }
            .task {
                if preview == nil {
                    let sample = SavedGame(settings: GameSettings(opponent: .local), moves:
                        ["a7", "f6", "d6", "g1", "c5", "d3"].enumerated().map { MoveRecord(notation: $0.element, side: $0.offset % 2) })
                    preview = try? Engine.query(sample)
                }
                if ProcessInfo.processInfo.arguments.contains("-ui-demo"), path.isEmpty { path = ["game"] }
            }
        }
    }
    private var heading: some View {
        HStack(spacing: 14) {
            BrandMark()
            Text(L10n.text("app_name")).font(.system(.largeTitle, design: .serif).weight(.medium))
                .foregroundStyle(Color.ink).lineLimit(2)
        }.frame(maxWidth: .infinity)
    }
    private var illustration: some View {
        GeometryReader { geometry in
            let side = max(0, min(geometry.size.width, geometry.size.height, 420))
            if let preview, side >= 100 {
                BoardView(position: preview, interactive: false)
                    .frame(width: side, height: side)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .accessibilityHidden(true)
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    private func actions(horizontal: Bool = false) -> some View {
        let layout = horizontal ? AnyLayout(HStackLayout(spacing: 16)) : AnyLayout(VStackLayout(spacing: 10))
        return layout {
            if store.game != nil {
                Button { path.append("game") } label: {
                    Text(L10n.text(store.position?.isOver == true ? "view_game" : "continue_game"))
                        .multilineTextAlignment(.center)
                }.buttonStyle(PrimaryButton()).accessibilityIdentifier("continue_game")
            }
            Button { showingNewGame = true } label: {
                Label(L10n.text("new_game"), systemImage: "plus")
                    .frame(maxWidth: .infinity).padding(.vertical, 15)
            }
            .font(.headline).foregroundStyle(store.game == nil ? Color("AccentContent") : Color.petrol)
            .background(store.game == nil ? Color.petrol : Color.boardSurface, in: RoundedRectangle(cornerRadius: 18))
            .accessibilityIdentifier("new_game")
            Button { showingRules = true } label: { Label(L10n.text("rules"), systemImage: "book.closed") }
                .font(.body).frame(minHeight: 44).accessibilityIdentifier("learn_rules")
        }.frame(maxWidth: horizontal ? .infinity : 420).frame(maxWidth: .infinity)
    }

}
