// SPDX-License-Identifier: AGPL-3.0-or-later
import SwiftUI

struct GameView: View {
    @Bindable var store: GameStore
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.dynamicTypeSize) private var dynamicType
    @Environment(AppPreferences.self) private var preferences
    @State private var showingHistory = false
    @State private var showingRules = false
    @State private var showingNewGame = false
    @State private var showingMoves = false
    @State private var showingHintExplanation = false
    @State private var showingDisplayOptions = false
    @State private var showingComputerOptions = false

    var body: some View {
        GeometryReader { geometry in
            if let position = store.position, let game = store.game {
                let horizontal = geometry.size.width > geometry.size.height
                Group {
                    if horizontal {
                        HStack(spacing: 20) {
                            fittedBoard(position)
                            VStack(spacing: 10) {
                                status(position, compact: true)
                                Spacer(minLength: 0)
                                if !dynamicType.isAccessibilitySize { players(position, game: game) }
                                controls(position)
                                if !dynamicType.isAccessibilitySize { phaseNote(position) }
                            }.frame(width: min(360, geometry.size.width * 0.44))
                        }
                    } else {
                        VStack(spacing: 12) {
                            status(position, compact: dynamicType.isAccessibilitySize)
                            if !dynamicType.isAccessibilitySize { players(position, game: game) }
                            fittedBoard(position)
                            controls(position)
                            if !dynamicType.isAccessibilitySize { phaseNote(position) }
                        }
                    }
                }
                .padding(12).frame(maxWidth: 1120).frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }.background(Color.limestone)
        .navigationTitle(L10n.text("app_name")).navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button(L10n.text("new_game"), systemImage: "plus") { showingNewGame = true }
                    Button(L10n.text("rules"), systemImage: "book.closed") { showingRules = true }
                    Button(L10n.text("legal_moves"), systemImage: "square.grid.3x3") { showingMoves = true }
                        .disabled(!store.isHumanTurn || store.isThinking)
                    Button(L10n.text("display_options"), systemImage: "gearshape") { showingDisplayOptions = true }
                    if store.game?.settings.opponent == .computer {
                        Button(L10n.text("computer_options"), systemImage: "slider.horizontal.3") { showingComputerOptions = true }
                    }
                } label: { Image(systemName: "ellipsis") }.accessibilityLabel(L10n.text("game_options")).accessibilityIdentifier("game_options")
            }
        }
        .sheet(isPresented: $showingHistory) { HistoryView(game: store.game, position: store.position) }
        .sheet(isPresented: $showingRules) { RulesView(variant: store.game?.settings.variant ?? .classic) }
        .sheet(isPresented: $showingNewGame) { NewGameView(hasOngoingGame: store.hasOngoingGame) { store.start($0) } }
        .sheet(isPresented: $showingMoves) { LegalMovesView(store: store) }
        .sheet(isPresented: $showingDisplayOptions) { DisplayOptionsView() }
        .sheet(isPresented: $showingComputerOptions) {
            if let game = store.game { ComputerOptionsView(settings: game.settings, apply: store.updateComputerSettings) }
        }
        .sheet(isPresented: $showingHintExplanation) {
            if let explanation = store.hintExplanation {
                ReadingSheet(title: L10n.text("hint_explanation"), text: explanation.text, compactHeight: 380)
            }
        }
        .onAppear { store.resumeComputer() }
        .onDisappear { store.suspend() }
        .onChange(of: scenePhase) { _, phase in
            if phase == .active { store.resumeComputer() } else { store.suspend() }
        }
        .sensoryFeedback(.selection, trigger: store.game?.moves.count ?? 0)
    }
    private func status(_ position: Position, compact: Bool) -> some View {
        VStack(spacing: 4) {
            ZStack {
                Text(statusText(position)).font(.system(.title2, design: .serif).weight(.medium))
                    .lineLimit(dynamicType.isAccessibilitySize ? 2 : 1, reservesSpace: true).multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity, minHeight: 44).padding(.horizontal, 24)
                    .accessibilityIdentifier("game_status")
                    .opacity(compact && store.hint != nil && !store.searchProgress.isVisible ? 0 : 1)
                    .accessibilityHidden(compact && store.hint != nil && !store.searchProgress.isVisible)
                    .overlay(alignment: .trailing) {
                        if store.searchProgress.isVisible {
                            ProgressView().controlSize(.small).frame(width: 24)
                                .accessibilityLabel(L10n.text(store.activity == .hint ? "hint_thinking" : "computer_turn"))
                                .accessibilityIdentifier("search_progress")
                        }
                    }
                if compact, store.hint != nil, !store.searchProgress.isVisible { hintLine }
            }
            if !compact {
                ZStack {
                    Text(instruction(position)).font(.subheadline).foregroundStyle(Color.quietInk)
                        .lineLimit(2, reservesSpace: true).multilineTextAlignment(.center)
                        .opacity(store.hint != nil && !store.searchProgress.isVisible ? 0 : 1)
                        .accessibilityHidden(store.hint != nil && !store.searchProgress.isVisible)
                    if store.hint != nil, !store.searchProgress.isVisible { hintLine }
                }.frame(maxWidth: .infinity, minHeight: 44)
            }
        }.foregroundStyle(Color.ink).fixedSize(horizontal: false, vertical: true)
    }
    private var hintLine: some View {
        HStack(spacing: 4) {
            Text(L10n.format("hint_move", store.hint?.notation ?? ""))
                .font(.subheadline).multilineTextAlignment(.center).lineLimit(2)
                .accessibilityIdentifier("hint_suggestion")
            Button { showingHintExplanation = true } label: {
                Image(systemName: "info.circle").font(.system(size: 20)).frame(width: 44, height: 44)
            }.buttonStyle(.plain).accessibilityLabel(L10n.text("hint_explanation"))
                .accessibilityIdentifier("hint_explanation")
                .disabled(store.hintExplanation == nil)
        }.frame(maxWidth: .infinity, minHeight: 44).foregroundStyle(Color.petrol)
    }
    private func statusText(_ position: Position) -> String {
        if position.isOver {
            return position.outcome == "draw" ? L10n.text("draw") : L10n.format("wins", L10n.text(position.winner == 0 ? "white" : "black"))
        }
        if store.activity == .hint && store.searchProgress.isVisible { return L10n.text("hint_thinking") }
        if store.activity == .computer { return L10n.text("computer_turn") }
        if position.action == 2 { return L10n.text("mill_formed") }
        if store.game?.settings.opponent == .computer && position.side == 0 { return L10n.text("your_turn") }
        return L10n.format("side_to_move", L10n.text(position.side == 0 ? "white" : "black"))
    }
    private func instruction(_ position: Position) -> String {
        if position.isOver { return L10n.text("game_finished") }
        if store.activity == .computer {
            return L10n.text(position.action == 2 ? "computer_capture" : "computer_considers")
        }
        if store.activity == .hint && store.searchProgress.isVisible { return L10n.text("hint_considers") }
        if let hint = store.hint { return L10n.format("hint_move", hint.notation) }
        if position.action == 2 { return L10n.text(preferences.showLegalMoves ? "capture_instruction" : "capture_unmarked") }
        if store.selectedNode != nil { return L10n.text(preferences.showLegalMoves ? "destination_instruction" : "destination_unmarked") }
        if preferences.showLastMove, store.game?.settings.opponent == .computer, store.game?.moves.last?.side == 1,
           !position.lastTurn.isEmpty {
            let actions = position.lastTurn.map { action in
                let target = position.nodes[action.to].label
                switch action.kind {
                case 0: return L10n.format("last_placed_at", target)
                case 1: return "\(position.nodes[action.from].label) → \(target)"
                default: return L10n.format("last_removed_at", target)
                }
            }.joined(separator: " · ")
            return L10n.format("computer_did", actions)
        }
        return L10n.text(position.phase == 2 ? "move_instruction" : store.game?.settings.variant == .lasker ? "lasker_instruction" : "place_instruction")
    }
    private func fittedBoard(_ position: Position) -> some View {
        GeometryReader { geometry in
            let side = max(0, min(geometry.size.width, geometry.size.height, 700))
            BoardView(position: position, moves: store.game?.moves, animateStones: preferences.animateStones,
                      selected: store.selectedNode, hint: store.hint,
                      recentActions: preferences.showLastMove ? position.lastTurn : [], showLegalMoves: preferences.showLegalMoves,
                      interactive: store.isHumanTurn && !store.isThinking, tap: store.tap)
                .id(store.boardID)
                .frame(width: side, height: side)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    private func players(_ position: Position, game: SavedGame) -> some View {
        HStack(spacing: 12) {
            player(0, position: position, game: game)
            Spacer(minLength: 0)
            player(1, position: position, game: game)
        }.fixedSize(horizontal: false, vertical: true)
    }
    private func player(_ side: Int, position: Position, game: SavedGame) -> some View {
        HStack(spacing: 6) {
            Stone(side: side, selected: position.side == side && !position.isOver, size: 24)
            Text(L10n.format("reserve_count", position.hand[side])).font(.caption).lineLimit(1)
        }
        .foregroundStyle(Color.quietInk)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(L10n.format("side_counts", L10n.text(side == 1 && game.settings.opponent == .computer ? "computer" : side == 0 ? "white" : "black"), position.onBoard[side], position.hand[side]))
        .accessibilityIdentifier("player_\(side)")
    }
    private func controls(_ position: Position) -> some View {
        HStack(spacing: 0) {
            if position.isOver {
                control("play_again", icon: "plus", disabled: false) { showingNewGame = true }
            } else if !store.isHumanTurn && !store.isThinking {
                control("resume_computer", icon: "play.fill", disabled: false) { store.resumeComputer() }
            } else {
                control("undo", icon: "arrow.uturn.backward", disabled: !store.canUndo) { store.undo() }
            }
            control("hint", icon: "lightbulb", disabled: !store.isHumanTurn) { store.requestHint() }
            if dynamicType.isAccessibilitySize {
                control("legal_moves", icon: "square.grid.3x3", disabled: !store.isHumanTurn || store.isThinking) { showingMoves = true }
            }
            control("history", icon: "list.bullet", disabled: false) { showingHistory = true }
        }.background(Color.boardSurface, in: RoundedRectangle(cornerRadius: 18))
    }
    private func control(_ key: String, icon: String, disabled: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon).font(.system(size: 21))
                if !dynamicType.isAccessibilitySize { Text(L10n.text(key)).font(.caption).lineLimit(1) }
            }.frame(maxWidth: .infinity).frame(height: 56)
        }.disabled(disabled).accessibilityLabel(L10n.text(key)).accessibilityIdentifier(key)
    }
    private func phaseNote(_ position: Position) -> some View {
        HStack(spacing: 8) {
            Circle().fill(Color.petrol).frame(width: 5, height: 5)
            Text(L10n.text(position.isOver ? "finished" : position.action == 2 ? "capture_phase" : position.phase == 2 ? "moving_phase" : "placing_phase"))
            Circle().fill(Color.quietInk).frame(width: 3, height: 3).accessibilityHidden(true)
            Text(L10n.moveCount(store.game?.moves.count ?? 0))
        }.font(.caption).foregroundStyle(Color.quietInk).lineLimit(1)
    }
}
