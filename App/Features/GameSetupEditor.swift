// SPDX-License-Identifier: AGPL-3.0-or-later
import SwiftUI

/// Give iPad form sheets an explicit proposal: a GeometryReader has no intrinsic height.
/// iPhone detents and the presentation system still constrain this to the available screen.
struct SettingsSheetSizing: PresentationSizing {
    let height: CGFloat
    func proposedSize(for root: PresentationSizingRoot, context: PresentationSizingContext) -> ProposedViewSize {
        ProposedViewSize(width: 540, height: height)
    }
}

/// One draft shared by setup and the in-game computer sheet. No settings navigation stack.
struct GameSetupEditor: View {
    @Environment(\.dynamicTypeSize) private var dynamicType
    @Binding var settings: GameSettings
    @Binding var expanded: Bool
    var includesGame = true
    @State private var panel = Panel.opponent
    @State private var help: Help?
    @ScaledMetric(relativeTo: .subheadline) private var advancedLabelWidth: CGFloat = 118

    private enum Panel: String, CaseIterable {
        case opponent, difficulty, variant, advanced
        var icon: String {
            switch self { case .opponent: "person.2"; case .difficulty: "slider.horizontal.3"; case .variant: "square.grid.2x2"; case .advanced: "gearshape" }
        }
        var key: String { self == .advanced ? "advanced_options" : rawValue }
    }
    private struct Help: Identifiable { let id: String; let title: String; let text: String }

    var body: some View {
        GeometryReader { geometry in
            let wide = geometry.size.width > 560
            ViewThatFits(in: .vertical) {
                fullControls(wide: wide).frame(width: geometry.size.width).fixedSize(horizontal: false, vertical: true)
                compactControls(wide: wide)
            }.frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        }
        .sheet(item: $help) { item in ReadingSheet(title: item.title, text: item.text) }
        .onChange(of: expanded) { _, open in if open { panel = .advanced } }
        .onChange(of: settings.opponent) { _, opponent in
            if opponent == .local { expanded = false; panel = .opponent }
        }
    }

    private func fullControls(wide: Bool) -> some View {
        VStack(spacing: 8) {
            if includesGame && wide {
                HStack(alignment: .top, spacing: 24) {
                    VStack(spacing: 8) { opponent; if settings.opponent == .computer { difficulty } }
                        .frame(maxWidth: .infinity)
                    variants().frame(maxWidth: .infinity)
                }
            } else {
                if includesGame { opponent }
                if settings.opponent == .computer { difficulty }
                if includesGame { variants() }
            }
            if settings.opponent == .computer {
                Button { withAnimation(.easeInOut(duration: 0.2)) { expanded.toggle() } } label: {
                    HStack {
                        Text(L10n.text("advanced_options"))
                        Spacer()
                        Image(systemName: expanded ? "chevron.up" : "chevron.down").font(.system(size: 13, weight: .semibold))
                    }.font(.subheadline).frame(minHeight: 44).contentShape(Rectangle())
                }.buttonStyle(.plain).foregroundStyle(Color.petrol)
                    .accessibilityValue(L10n.text(expanded ? "expanded" : "collapsed"))
                    .accessibilityIdentifier("advanced_options")
                if expanded { advanced(wide: wide) }
            }
        }
    }

    // At very large text sizes or low landscape heights, keep controls on this same sheet.
    // Compact tabs replace clipped content; the main setup never scrolls beneath a finger.
    private func compactControls(wide: Bool) -> some View {
        let panels: [Panel] = includesGame
            ? (settings.opponent == .computer ? Panel.allCases : [.opponent, .variant])
            : [.difficulty, .advanced]
        let selected = panels.contains(panel) ? panel : panels[0]
        return VStack(spacing: 8) {
            HStack(spacing: 8) {
                ForEach(panels, id: \.self) { item in
                    Button { panel = item } label: {
                        Image(systemName: item.icon).font(.system(size: 23))
                            .frame(maxWidth: .infinity, minHeight: 44)
                            .background(selected == item ? Color.petrol.opacity(0.13) : Color.boardSurface, in: RoundedRectangle(cornerRadius: 12))
                    }.buttonStyle(.plain).foregroundStyle(Color.petrol)
                        .accessibilityLabel(L10n.text(item.key))
                        .accessibilityAddTraits(selected == item ? .isSelected : [])
                        .accessibilityIdentifier("setup_tab_" + item.rawValue)
                }
                if selected == .variant { info("variant_help") }
            }
            switch selected {
            case .opponent: opponent
            case .difficulty: difficulty
            case .variant: variants(showHeading: false)
            case .advanced: advanced(wide: wide)
            }
        }
    }

    private var opponent: some View {
        HStack(spacing: 8) {
            ForEach(Opponent.allCases) { option in
                choice(L10n.text(option.rawValue), selected: settings.opponent == option, id: "opponent_" + option.rawValue) {
                    settings.opponent = option
                }
            }
        }.accessibilityElement(children: .contain).accessibilityLabel(L10n.text("opponent"))
    }
    private var difficulty: some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                Text(L10n.text("difficulty")).font(.subheadline).foregroundStyle(Color.ink)
                info("computer_help")
                Spacer(minLength: 0)
                Text("\(settings.level) · \(L10n.text("level_\(settings.level)"))")
                    .font(.subheadline).foregroundStyle(Color.petrol).multilineTextAlignment(.trailing)
                    .accessibilityIdentifier("difficulty_value")
            }
            Slider(value: Binding(get: { Double(settings.level) }, set: { settings.level = Int($0.rounded()) }), in: 1...5, step: 1)
                .accessibilityLabel(L10n.text("difficulty"))
                .accessibilityValue(L10n.format("level_badge", settings.level))
                .accessibilityIdentifier("difficulty_slider")
            HStack {
                ForEach(GameSettings.levels, id: \.self) { level in
                    if level > 1 { Spacer(minLength: 0) }
                    Text("\(level)").font(.caption.weight(level == settings.level ? .semibold : .medium)).monospacedDigit()
                        .foregroundStyle(Color.ink)
                }
            }.padding(.horizontal, 3).accessibilityHidden(true)
        }
    }
    private func variants(showHeading: Bool = true) -> some View {
        VStack(spacing: 4) {
            if showHeading { HStack { Text(L10n.text("variant")).font(.subheadline); info("variant_help"); Spacer(minLength: 0) } }
            VStack(spacing: 8) {
                ForEach(0..<2, id: \.self) { row in
                    HStack(spacing: 8) {
                        ForEach(Array(Variant.allCases[(row * 2)..<(row * 2 + 2)])) { variant in
                    Button { settings.variant = variant } label: {
                        HStack(spacing: 8) {
                            if !dynamicType.isAccessibilitySize { VariantMark(diagonal: variant == .twelve || variant == .morabaraba).frame(width: 30, height: 30) }
                            Text(L10n.text(variant.key + "_choice")).font(.subheadline).multilineTextAlignment(.leading)
                                .fixedSize(horizontal: false, vertical: true)
                            Spacer(minLength: 0)
                        }.padding(.horizontal, 10).padding(.vertical, 8).frame(maxWidth: .infinity, minHeight: 48)
                            .background(settings.variant == variant ? Color.petrol.opacity(0.12) : Color.boardSurface, in: RoundedRectangle(cornerRadius: 12))
                            .overlay { RoundedRectangle(cornerRadius: 12).strokeBorder(settings.variant == variant ? Color.petrol : .clear, lineWidth: 1.5) }
                    }.buttonStyle(.plain).foregroundStyle(settings.variant == variant ? Color.petrol : Color.ink)
                        .accessibilityAddTraits(settings.variant == variant ? .isSelected : [])
                        .accessibilityLabel(L10n.text(variant.key))
                        .accessibilityIdentifier("variant_" + variant.key)
                        }
                    }
                }
            }
        }.foregroundStyle(Color.ink)
    }
    private func advanced(wide: Bool) -> some View {
        VStack(spacing: 4) {
            let layout = dynamicType.isAccessibilitySize && !wide ? AnyLayout(VStackLayout(alignment: .leading, spacing: 4)) : AnyLayout(HStackLayout(spacing: 8))
            layout {
                HStack(spacing: 0) { Text(L10n.text("search_algorithm")).font(.subheadline); info("search_comparison") }
                    .frame(width: dynamicType.isAccessibilitySize ? nil : advancedLabelWidth, alignment: .leading)
                HStack(spacing: 6) {
                    ForEach(SearchAlgorithm.allCases, id: \.self) { algorithm in
                        choice(algorithm.name, selected: settings.algorithm == algorithm, id: "algorithm_" + algorithm.rawValue) { settings.algorithm = algorithm }
                    }
                }
            }
            layout {
                HStack(spacing: 0) { Text(L10n.text("search_effort")).font(.subheadline); info("search_help") }
                    .frame(width: dynamicType.isAccessibilitySize ? nil : advancedLabelWidth, alignment: .leading)
                HStack(spacing: 6) {
                    ForEach(SearchEffort.allCases, id: \.self) { effort in
                        choice(L10n.text("effort_" + effort.rawValue), selected: settings.effort == effort, id: "effort_" + effort.rawValue) { settings.effort = effort }
                    }
                }
            }
        }.foregroundStyle(Color.ink)
    }
    private func choice(_ title: String, selected: Bool, id: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title).font(.subheadline).multilineTextAlignment(.center).fixedSize(horizontal: false, vertical: true)
                .frame(maxWidth: .infinity, minHeight: 44)
                .background(selected ? Color.petrol.opacity(0.12) : Color.boardSurface, in: RoundedRectangle(cornerRadius: 12))
                .overlay { RoundedRectangle(cornerRadius: 12).strokeBorder(selected ? Color.petrol : .clear, lineWidth: 1.5) }
        }.buttonStyle(.plain).foregroundStyle(selected ? Color.petrol : Color.ink)
            .accessibilityAddTraits(selected ? .isSelected : [])
            .accessibilityIdentifier(id)
    }
    private func info(_ key: String) -> some View {
        Button { help = Help(id: key, title: L10n.text(key), text: L10n.text(key + "_body")) } label: {
            Image(systemName: "info.circle").font(.system(size: dynamicType.isAccessibilitySize ? 26 : 18))
                .frame(width: 44, height: 44).contentShape(Rectangle())
        }.buttonStyle(.plain).foregroundStyle(Color.petrol)
            .accessibilityLabel(L10n.text(key)).accessibilityIdentifier("info_" + key)
    }
}

private struct VariantMark: View {
    let diagonal: Bool
    var body: some View {
        Canvas { context, size in
            var lines = Path()
            for inset in [0.08, 0.23, 0.38] {
                lines.addRect(CGRect(x: size.width * inset, y: size.height * inset,
                                     width: size.width * (1 - 2 * inset), height: size.height * (1 - 2 * inset)))
            }
            for (start, end) in [(CGPoint(x: 0.5, y: 0.08), CGPoint(x: 0.5, y: 0.38)), (CGPoint(x: 0.5, y: 0.62), CGPoint(x: 0.5, y: 0.92)), (CGPoint(x: 0.08, y: 0.5), CGPoint(x: 0.38, y: 0.5)), (CGPoint(x: 0.62, y: 0.5), CGPoint(x: 0.92, y: 0.5))] {
                lines.move(to: CGPoint(x: start.x * size.width, y: start.y * size.height))
                lines.addLine(to: CGPoint(x: end.x * size.width, y: end.y * size.height))
            }
            if diagonal {
                for (x, y) in [(0.08, 0.08), (0.92, 0.08), (0.08, 0.92), (0.92, 0.92)] {
                    lines.move(to: CGPoint(x: x * size.width, y: y * size.height))
                    lines.addLine(to: CGPoint(x: (x < 0.5 ? 0.38 : 0.62) * size.width, y: (y < 0.5 ? 0.38 : 0.62) * size.height))
                }
            }
            context.stroke(lines, with: .foreground, lineWidth: 1)
        }.accessibilityHidden(true)
    }
}
