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
                    if let game { GameReplayView(game: game, startStep: step) }
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
            lines += [L10n.format("computer_configuration", game.settings.level, L10n.text("level_\(game.settings.level)")),
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
    @Environment(AppPreferences.self) private var preferences
    let game: SavedGame
    @State private var step: Int
    @State private var frame: ReplayFrame?
    init(game: SavedGame, startStep: Int) {
        self.game = game
        _step = State(initialValue: startStep)
        _frame = State(initialValue: try? game.replay(at: startStep))
    }
    var body: some View {
        GeometryReader { geometry in
            if let frame {
                Group {
                    if geometry.size.width > geometry.size.height {
                        HStack(spacing: 20) {
                            board(frame)
                            controls(frame).frame(width: geometry.size.width * 0.45)
                        }
                    } else {
                        VStack(spacing: 16) {
                            board(frame)
                            controls(frame)
                        }
                    }
                }.padding(20)
            } else { ContentUnavailableView(L10n.text("replay_unavailable"), systemImage: "exclamationmark.circle") }
        }.background(Color.limestone)
            .navigationTitle(L10n.text("replay_title")).navigationBarTitleDisplayMode(.inline)
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
            Text(L10n.format("replay_step", step, game.historyEntries.count))
                .font(.caption).monospacedDigit().foregroundStyle(Color.quietInk)
                .accessibilityIdentifier("replay_step")
            Slider(value: Binding(get: { Double(step) }, set: { step = Int($0) }),
                   in: 0...Double(max(1, game.historyEntries.count)), step: 1)
                .disabled(game.historyEntries.isEmpty)
                .accessibilityLabel(L10n.text("replay_title"))
                .accessibilityValue(L10n.format("replay_step", step, game.historyEntries.count))
                .accessibilityIdentifier("replay_slider")
            HStack(spacing: 0) {
                control("replay_first", icon: "backward.end", disabled: step == 0) { step = 0 }
                control("replay_previous", icon: "chevron.left", disabled: step == 0) { step -= 1 }
                control("replay_next", icon: "chevron.right", disabled: step == game.historyEntries.count) { step += 1 }
                control("replay_last", icon: "forward.end", disabled: step == game.historyEntries.count) { step = game.historyEntries.count }
            }.background(Color.boardSurface, in: RoundedRectangle(cornerRadius: 18))
        }
    }
    private func control(_ key: String, icon: String, disabled: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) { Image(systemName: icon).font(.system(size: 22)).frame(maxWidth: .infinity, minHeight: 52) }
            .foregroundStyle(palette.color).disabled(disabled).opacity(disabled ? 0.35 : 1)
            .accessibilityLabel(L10n.text(key)).accessibilityIdentifier(key)
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
