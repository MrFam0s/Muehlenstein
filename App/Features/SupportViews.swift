// SPDX-License-Identifier: AGPL-3.0-or-later
import SwiftUI

struct HistoryView: View {
    @Environment(\.accentPalette) private var palette
    @Environment(\.dismiss) private var dismiss
    @Environment(\.dynamicTypeSize) private var dynamicType
    // Freeze the viewed game while an AI/network turn may finish behind the sheet.
    @State private var game: SavedGame?
    @State private var position: Position?
    @State private var showsDetails = false
    @State private var replayStep: Int?
    init(game: SavedGame?, position: Position?) {
        _game = State(initialValue: game)
        _position = State(initialValue: position)
    }
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Picker(L10n.text("history"), selection: $showsDetails) {
                    Text(L10n.text("history_moves")).tag(false)
                    Text(L10n.text("game_details")).tag(true)
                }.pickerStyle(.segmented).padding(.horizontal, 16).padding(.top, 8)
                    .accessibilityIdentifier("history_section")
                if showsDetails { PagedReadingView(text: details) }
                else if let game, !game.historyEntries.isEmpty {
                    Button { replayStep = 0 } label: {
                        Label(L10n.text("replay_game"), systemImage: "play.rectangle")
                            .font(.subheadline.weight(.medium)).frame(maxWidth: .infinity, minHeight: 44)
                    }.accessibilityIdentifier("replay_game").padding(.horizontal, 16).padding(.top, 8)
                    let active = game.activeHistoryMoves
                    PagedGrid(items: game.historyEntries) { index, entry in
                        Button { replayStep = index + 1 } label: { HStack(spacing: 6) {
                            if entry.kind == .move {
                                Text("\(entry.moveNumber)").font(.caption2).monospacedDigit().foregroundStyle(Color.quietInk)
                                Stone(side: entry.side, size: 14)
                                Text(entry.notation).font(.system(.body, design: .monospaced))
                                    .strikethrough(!active.contains(index))
                                    .foregroundStyle(active.contains(index) ? Color.ink : Color.quietInk)
                            } else {
                                Image(systemName: entry.kind == .hint ? "lightbulb" : "arrow.uturn.backward")
                                Text(entry.kind == .hint ? L10n.format("history_hint", entry.notation) : L10n.format("history_undo", entry.moveNumber, entry.remainingMoves))
                                    .font(.caption).lineLimit(2)
                            }
                            Spacer(minLength: 0)
                            Image(systemName: "chevron.right").font(.caption2).foregroundStyle(palette.color)
                        }.padding(.horizontal, 8).frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(Color.boardSurface, in: RoundedRectangle(cornerRadius: 10))
                        }.buttonStyle(.plain).foregroundStyle(Color.ink)
                            .accessibilityLabel(historyLabel(entry, undone: entry.kind == .move && !active.contains(index)))
                            .accessibilityIdentifier("history_\(entry.kind.rawValue)_\(index)")
                    }
                } else { ContentUnavailableView(L10n.text("no_moves"), systemImage: "list.bullet") }
            }.background(Color.limestone)
                .navigationTitle(L10n.text("history")).navigationBarTitleDisplayMode(.inline)
                .toolbar { ToolbarItem(placement: .confirmationAction) { Button(L10n.text("done")) { dismiss() } } }
                .navigationDestination(item: $replayStep) { step in
                    if let game { GameReplayView(game: game, finished: position?.isOver == true, startStep: step) }
                }
        }.presentationDetents(dynamicType.isAccessibilitySize || replayStep != nil ? [.large] : [.height(500), .large])
            .presentationSizing(SettingsSheetSizing(height: dynamicType.isAccessibilitySize || replayStep != nil ? 760 : 500))
    }
    private func historyLabel(_ entry: GameHistoryEntry, undone: Bool) -> String {
        switch entry.kind {
        case .move:
            return "\(entry.moveNumber), \(L10n.text(entry.side == 0 ? "white" : "black")), \(entry.notation)" + (undone ? ", " + L10n.text("move_undone") : "")
        case .hint: return L10n.format("history_hint", entry.notation)
        case .undo: return L10n.format("history_undo", entry.moveNumber, entry.remainingMoves)
        }
    }
    private var details: String {
        guard let game, let position else { return L10n.text("no_moves") }
        let outcome = position.isOver
            ? (position.outcome == "draw" ? L10n.text("draw") : L10n.format("wins", L10n.text(position.winner == 0 ? "white" : "black")))
            : L10n.format("side_to_move", L10n.text(position.side == 0 ? "white" : "black"))
        var lines = [L10n.text(game.settings.variant.key), outcome]
        if game.settings.opponent != .network { lines.append(game.assistanceSummary) }
        lines += [
            L10n.text(position.isOver ? "finished" : position.action == 2 ? "capture_phase" : position.phase == 2 ? "moving_phase" : "placing_phase"),
            L10n.moveCount(game.moves.count),
            L10n.format("side_counts", L10n.text("white"), position.onBoard[0], position.hand[0]),
            L10n.format("side_counts", L10n.text("black"), position.onBoard[1], position.hand[1])]
        if game.settings.opponent == .computer {
            let strength = L10n.format("computer_configuration", game.settings.level, L10n.text("level_\(game.settings.level)"))
            lines += [game.settings.adaptive ? strength + " · " + L10n.text("strength_auto") : strength,
                L10n.text("computer_style") + ": " + L10n.text("style_" + game.settings.style.rawValue),
                game.settings.algorithm.name + " · " + L10n.text("effort_" + game.settings.effort.rawValue),
                L10n.text("opening_book") + ": " + L10n.text(game.settings.openingBook ? "book_automatic" : "book_off")]
        } else { lines.append(L10n.text(game.settings.opponent.rawValue)) }
        return lines.joined(separator: "\n\n")
    }
}

private struct GameReplayView: View {
    @Environment(\.accentPalette) private var palette
    @Environment(\.dynamicTypeSize) private var dynamicType
    @Environment(\.usesCompactSideToolbar) private var usesCompactSideToolbar
    @Environment(AppPreferences.self) private var preferences
    let game: SavedGame
    let finished: Bool
    @State private var step: Int
    @State private var frame: ReplayFrame?
    init(game: SavedGame, finished: Bool, startStep: Int) {
        self.finished = finished
        self.game = game
        _step = State(initialValue: startStep)
        _frame = State(initialValue: try? game.replay(at: startStep))
    }
    var body: some View {
        Group {
            if let frame {
                ReplayLayout { board(frame) } controls: { controls(frame) }
            } else { ContentUnavailableView(L10n.text("replay_unavailable"), systemImage: "exclamationmark.circle") }
        }.background(Color.limestone)
            .navigationTitle(L10n.text("replay_title")).navigationBarTitleDisplayMode(.inline)
            .toolbar {
                if usesCompactSideToolbar, frame != nil {
                    ToolbarItemGroup(placement: .bottomBar) { replayButtons }
                }
            }
            .onChange(of: step) { _, value in frame = try? game.replay(at: value) }
    }
    private func board(_ frame: ReplayFrame) -> some View {
        GeometryReader { geometry in
            let side = max(0, min(geometry.size.width, geometry.size.height))
            BoardView(position: frame.position, moves: frame.moves, animateStones: preferences.animateStones,
                      selected: frame.entry?.kind == .hint && frame.highlight?.kind == 1 ? frame.highlight?.from : nil,
                      hint: frame.entry?.kind == .hint ? frame.highlight : nil,
                      recentActions: frame.entry?.kind == .hint && frame.highlight?.kind != 1 ? [] : frame.highlight.map { [$0] } ?? [],
                      showLegalMoves: false, interactive: false)
                .frame(width: side, height: side).frame(maxWidth: .infinity, maxHeight: .infinity)
                .accessibilityElement(children: .contain)
                .accessibilityIdentifier("replay_board")
        }
    }
    private func controls(_ frame: ReplayFrame) -> some View {
        VStack(spacing: 12) {
            Text(frame.caption).font(.headline).foregroundStyle(Color.ink)
                .multilineTextAlignment(.center).fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, minHeight: dynamicType.isAccessibilitySize ? 70 : 44)
                .accessibilityIdentifier("replay_caption")
            if let request = MoveAnalysisRequest(game: game, finished: finished, frame: frame) {
                NavigationLink {
                    MoveAnalysisView(request: request, playedFrame: frame)
                } label: {
                    Label(L10n.text("analysis_action"), systemImage: "magnifyingglass")
                        .frame(minHeight: 44)
                }.accessibilityIdentifier("analyze_move")
            }
            Text(L10n.format("replay_step", step, game.historyEntries.count))
                .font(.caption).monospacedDigit().foregroundStyle(Color.quietInk)
                .accessibilityIdentifier("replay_step")
            Slider(value: Binding(get: { Double(step) }, set: { step = Int($0) }),
                   in: 0...Double(max(1, game.historyEntries.count)), step: 1)
                .disabled(game.historyEntries.isEmpty)
                .accessibilityLabel(L10n.text("replay_title"))
                .accessibilityValue(L10n.format("replay_step", step, game.historyEntries.count))
                .accessibilityIdentifier("replay_slider")
            if !usesCompactSideToolbar {
                HStack(spacing: 0) { replayButtons }
                    .labelStyle(ReplayButtonLabelStyle())
                    .foregroundStyle(palette.color)
                    .background(Color.boardSurface, in: RoundedRectangle(cornerRadius: 18))
            }
        }
    }

    @ViewBuilder private var replayButtons: some View {
        control("replay_first", icon: "backward.end", disabled: step == 0) { step = 0 }
        control("replay_previous", icon: "chevron.left", disabled: step == 0) { step -= 1 }
        control("replay_next", icon: "chevron.right", disabled: step == game.historyEntries.count) { step += 1 }
        control("replay_last", icon: "forward.end", disabled: step == game.historyEntries.count) { step = game.historyEntries.count }
    }

    private func control(_ key: String, icon: String, disabled: Bool, action: @escaping () -> Void) -> some View {
        Button(L10n.text(key), systemImage: icon, action: action)
            .disabled(disabled)
            .accessibilityLabel(L10n.text(key))
            .accessibilityIdentifier(key)
    }

    private struct ReplayButtonLabelStyle: LabelStyle {
        @Environment(\.isEnabled) private var isEnabled
        func makeBody(configuration: Configuration) -> some View {
            configuration.icon.font(.system(size: 22)).frame(maxWidth: .infinity, minHeight: 52)
                .opacity(isEnabled ? 1 : 0.35)
        }
    }
}

private struct ReplayLayout<Board: View, Controls: View>: View {
    @ViewBuilder let board: () -> Board
    @ViewBuilder let controls: () -> Controls

    var body: some View {
        GeometryReader { geometry in
            Group {
                if #available(iOS 27.1, *), !geometry.reservedRegions(kind: .division).isEmpty {
                    ArrangementView { board() } secondary: {
                        controls().frame(maxWidth: 420).padding(.horizontal, 8)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }.arrangementViewStyle(.split)
                } else if geometry.size.width > geometry.size.height {
                    HStack(spacing: 20) {
                        board()
                        controls().frame(width: geometry.size.width * 0.45)
                    }
                } else {
                    VStack(spacing: 16) {
                        board()
                        controls()
                    }
                }
            }.padding(20)
        }
    }
}

private struct MoveAnalysisView: View {
    let request: MoveAnalysisRequest
    let playedFrame: ReplayFrame
    @State private var result: MoveAnalysis?
    @State private var showPlayed = false
    @State private var failed = false
    @State private var attempt = 0

    var body: some View {
        ReplayLayout {
            GeometryReader { geometry in
                let recommendation = showPlayed ? nil : result
                let side = min(geometry.size.width, geometry.size.height)
                BoardView(position: recommendation?.position ?? playedFrame.position,
                          moves: recommendation?.moves ?? playedFrame.moves,
                          animateStones: false, recentActions: [recommendation?.choice ?? request.played],
                          showLegalMoves: false, interactive: false)
                    .frame(width: side, height: side).frame(maxWidth: .infinity, maxHeight: .infinity)
                    .accessibilityElement(children: .contain).accessibilityIdentifier("analysis_board")
            }
        } controls: {
            ViewThatFits(in: .vertical) {
                comparison.fixedSize(horizontal: false, vertical: true)
                ScrollView { comparison }
            }
        }
        .background(Color.limestone)
        .navigationTitle(L10n.text("analysis_title")).navigationBarTitleDisplayMode(.inline)
        .task(id: attempt) {
            do {
                failed = false
                let token = try SearchCancellation()
                let answer = try await withTaskCancellationHandler {
                    try await Task.detached(priority: .userInitiated) { [request] in
                        try request.evaluate(cancellation: token)
                    }.value
                } onCancel: { token.cancel() }
                try Task.checkCancellation()
                result = answer
            } catch {
                if !Task.isCancelled { failed = true }
            }
        }
    }

    private var comparison: some View {
        VStack(alignment: .leading, spacing: 12) {
            if let result {
                if result.choice == request.played {
                    Text(L10n.text("analysis_match")).font(.headline)
                        .accessibilityIdentifier("analysis_match")
                    Text(request.played.description(in: playedFrame.position))
                } else {
                    moveButton("analysis_played", action: request.played, played: true)
                    moveButton("analysis_suggested", action: result.choice, played: false)
                }
                if result.choice != request.played {
                    Text(L10n.text("hint_explanation")).font(.subheadline.weight(.semibold))
                }
                Text(result.explanation).font(.subheadline)
                    .fixedSize(horizontal: false, vertical: true)
                    .accessibilityIdentifier("analysis_explanation")
            } else if failed {
                Text(L10n.text("engine_error"))
                Button(L10n.text("analysis_retry")) { attempt += 1 }
            } else {
                ProgressView(L10n.text("analysis_calculating"))
            }
        }.foregroundStyle(Color.ink).frame(maxWidth: .infinity, alignment: .leading)
    }

    private func moveButton(_ key: String, action: EngineAction, played: Bool) -> some View {
        Button {
            showPlayed = played
        } label: {
            HStack(spacing: 12) {
                Image(systemName: showPlayed == played ? "checkmark.circle.fill" : "circle")
                    .accessibilityHidden(true)
                VStack(alignment: .leading, spacing: 2) {
                    Text(L10n.text(key)).font(.caption).foregroundStyle(Color.quietInk)
                    Text(action.description(in: playedFrame.position)).font(.headline).foregroundStyle(Color.ink)
                }
                Spacer(minLength: 0)
            }
            .padding(.horizontal, 12).padding(.vertical, 6).frame(minHeight: 44)
            .background(Color.boardSurface, in: RoundedRectangle(cornerRadius: 12))
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(showPlayed == played ? .isSelected : [])
        .accessibilityIdentifier(key)
    }
}

struct LegalMovesView: View {
    @Environment(\.accentPalette) private var palette
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
                }.buttonStyle(.plain).foregroundStyle(palette.color)
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
