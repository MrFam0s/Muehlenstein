// SPDX-License-Identifier: AGPL-3.0-or-later
import SwiftUI

extension Color {
    static let limestone = Color("Limestone")
    static let boardSurface = Color("BoardSurface")
    static let ink = Color("Ink")
    static let quietInk = Color("QuietInk")
    static let boardLine = Color("BoardLine")
}

private struct AccentPaletteKey: EnvironmentKey {
    static let defaultValue = AccentPalette.forest
}
extension EnvironmentValues {
    var accentPalette: AccentPalette {
        get { self[AccentPaletteKey.self] }
        set { self[AccentPaletteKey.self] = newValue }
    }
}
extension AccentPalette {
    var color: Color { Color(assetName) }
    // A marker lies on the stone, so its contrast follows the stone rather than the system appearance.
    func stoneMark(side: Int) -> Color {
        let traits = UITraitCollection(userInterfaceStyle: side == 0 ? .light : .dark)
        return Color(uiColor: UIColor(named: assetName)?.resolvedColor(with: traits) ?? .label)
    }
}
struct Stone: View {
    @Environment(\.accentPalette) private var palette
    var side: Int
    var selected = false
    var size: CGFloat = 30
    var body: some View {
        Circle()
            .fill(LinearGradient(colors: [Color(side == 0 ? "WhiteStoneTop" : "BlackStoneTop"),
                                          Color(side == 0 ? "WhiteStoneBottom" : "BlackStoneBottom")],
                                 startPoint: .topLeading, endPoint: .bottomTrailing))
            .overlay { Circle().strokeBorder(Color("StoneEdge"), lineWidth: 1.5) }
            .overlay { Circle().inset(by: size * 0.21).strokeBorder(side == 0 ? Color.black.opacity(0.09) : Color.white.opacity(0.13), lineWidth: 1) }
            .shadow(color: .black.opacity(0.18), radius: 2, y: 2)
            .padding(4)
            .overlay { if selected { Circle().strokeBorder(palette.color, lineWidth: 2) } }
            .frame(width: size + 8, height: size + 8)
            .accessibilityHidden(true)
    }
}
struct PrimaryButton: ButtonStyle {
    @Environment(\.accentPalette) private var palette
    func makeBody(configuration: Configuration) -> some View {
        configuration.label.font(.headline).frame(maxWidth: .infinity).padding(.vertical, 17)
            .foregroundStyle(Color("AccentContent")).background(palette.color, in: RoundedRectangle(cornerRadius: 18))
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
    }
}
struct BrandMark: View {
    @Environment(\.accentPalette) private var palette
    var body: some View {
        ZStack {
            // Both vector layers share the app icon's geometry and preserve
            // the approved wordmark layout while following the chosen palette.
            Image("BrandBoard").resizable().scaledToFit().foregroundStyle(palette.color)
            Image("BrandStone").resizable().scaledToFit().foregroundStyle(Color.ink)
        }.frame(width: 52, height: 52).accessibilityHidden(true)
    }
}
