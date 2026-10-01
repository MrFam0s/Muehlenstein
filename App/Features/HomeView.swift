// SPDX-License-Identifier: AGPL-3.0-or-later
import SwiftUI

struct HomeView: View {
    @Bindable var store: GameStore
    @Environment(\.dynamicTypeSize) private var dynamicType
    @Environment(\.verticalSizeClass) private var verticalSize
    @State private var showingNewGame = false
    @State private var showingAbout = false
    @State private var showingRules = false
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
                            VStack(spacing: 32) { heading; actions() }
                                .frame(maxWidth: 420)
                        }
                    } else {
                        HomeComposition(spacing: geometry.size.height < 600 ? 20 : 28) {
                            heading
                            previewBoard
                            actions()
                        }
                    }
                }
                .padding(20).frame(maxWidth: 900).frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .background(Color.limestone)
            .navigationTitle(verticalSize == .compact && dynamicType.isAccessibilitySize ? L10n.text("app_name") : "")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button { showingRules = true } label: { Image(systemName: "book.closed") }
                        .accessibilityLabel(L10n.text("rules")).accessibilityIdentifier("learn_rules")
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button { showingAbout = true } label: { Image(systemName: "info.circle") }
                        .accessibilityLabel(L10n.text("about")).accessibilityIdentifier("about")
                }
            }
            .navigationDestination(for: String.self) { _ in GameView(store: store) }
            .sheet(isPresented: $showingNewGame) {
                NewGameView(hasOngoingGame: store.hasOngoingGame) { settings in
                    store.start(settings)
                    if store.position != nil { path = ["game"] }
                }
            }
            .sheet(isPresented: $showingAbout) { AboutView() }
            .sheet(isPresented: $showingRules) { RulesView(variant: .classic) }
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
                .accessibilityIdentifier("home_title")
        }.frame(maxWidth: .infinity)
    }
    private var illustration: some View {
        GeometryReader { geometry in
            let side = max(0, min(geometry.size.width, geometry.size.height, 420))
            previewBoard.frame(width: side, height: side)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    private var previewBoard: some View {
        GeometryReader { geometry in
            if let preview, min(geometry.size.width, geometry.size.height) >= 100 {
                BoardView(position: preview, interactive: false)
            }
        }.accessibilityHidden(true)
    }
    private func actions(horizontal: Bool = false) -> some View {
        let layout = horizontal ? AnyLayout(HStackLayout(spacing: 16)) : AnyLayout(VStackLayout(spacing: 10))
        return layout {
            if store.game != nil {
                Button { path.append("game") } label: {
                    Text(L10n.text(store.position?.isOver == true ? "view_game" : "continue_game"))
                        .multilineTextAlignment(.center).fixedSize(horizontal: false, vertical: true)
                }.buttonStyle(PrimaryButton()).accessibilityIdentifier("continue_game")
            }
            Button { showingNewGame = true } label: {
                Label(L10n.text("new_game"), systemImage: "plus")
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity).padding(.vertical, 15)
            }
            .font(.headline).foregroundStyle(store.game == nil ? Color("AccentContent") : Color.petrol)
            .background(store.game == nil ? Color.petrol : Color.boardSurface, in: RoundedRectangle(cornerRadius: 18))
            .accessibilityIdentifier("new_game")
        }.frame(maxWidth: horizontal ? .infinity : 420).frame(maxWidth: .infinity)
    }

}

/// Keep the brand, illustration and actions together. Measure text first so
/// the board yields space on short screens and at larger text sizes.
private struct HomeComposition: Layout {
    let spacing: CGFloat

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        CGSize(width: proposal.width ?? 420, height: proposal.height ?? 620)
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        guard subviews.count == 3 else { return }
        let width = min(bounds.width, 420)
        let textProposal = ProposedViewSize(width: width, height: nil)
        let headingHeight = subviews[0].sizeThatFits(textProposal).height
        let actionsHeight = subviews[2].sizeThatFits(textProposal).height
        let availableSide = max(0, min(width, bounds.height - headingHeight - actionsHeight - spacing * 2))
        let side = availableSide >= 120 ? availableSide : 0
        let gaps = spacing * (side > 0 ? 2 : 1)
        let height = headingHeight + side + actionsHeight + gaps
        let top = bounds.midY - height / 2
        subviews[0].place(at: CGPoint(x: bounds.midX, y: top), anchor: .top,
                          proposal: ProposedViewSize(width: width, height: headingHeight))
        subviews[1].place(at: CGPoint(x: bounds.midX, y: top + headingHeight + spacing), anchor: .top,
                          proposal: ProposedViewSize(width: side, height: side))
        subviews[2].place(at: CGPoint(x: bounds.midX, y: top + headingHeight + gaps + side), anchor: .top,
                          proposal: ProposedViewSize(width: width, height: actionsHeight))
    }
}
