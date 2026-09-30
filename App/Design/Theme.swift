// SPDX-License-Identifier: AGPL-3.0-or-later
import SwiftUI

extension Color {
    static let limestone = Color("Limestone")
    static let boardSurface = Color("BoardSurface")
    static let ink = Color("Ink")
    static let quietInk = Color("QuietInk")
    static let petrol = Color("AccentColor")
    static let boardLine = Color("BoardLine")
}
struct Stone: View {
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
            .overlay { if selected { Circle().strokeBorder(Color.petrol, lineWidth: 2) } }
            .frame(width: size + 8, height: size + 8)
            .accessibilityHidden(true)
    }
}
struct PrimaryButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label.font(.headline).frame(maxWidth: .infinity).padding(.vertical, 17)
            .foregroundStyle(Color("AccentContent")).background(Color.petrol, in: RoundedRectangle(cornerRadius: 18))
            .scaleEffect(configuration.isPressed ? 0.98 : 1)
    }
}
struct BrandMark: View {
    var body: some View {
        ZStack {
            Path { path in
                for inset: CGFloat in [5, 13.5, 22] {
                    path.addRect(CGRect(x: inset, y: inset, width: 52 - 2 * inset, height: 52 - 2 * inset))
                }
                for (start, end) in [(CGPoint(x: 26, y: 5), CGPoint(x: 26, y: 22)),
                                     (CGPoint(x: 26, y: 30), CGPoint(x: 26, y: 47)),
                                     (CGPoint(x: 5, y: 26), CGPoint(x: 22, y: 26)),
                                     (CGPoint(x: 30, y: 26), CGPoint(x: 47, y: 26))] {
                    path.move(to: start); path.addLine(to: end)
                }
            }.stroke(Color.petrol, style: StrokeStyle(lineWidth: 1.8, lineCap: .round, lineJoin: .round))
            ForEach([false, true], id: \.self) { dark in
                Circle().fill(Color.limestone).frame(width: 14, height: 14)
                    .overlay { Circle().fill(dark ? Color.ink : Color.petrol).frame(width: 10, height: 10) }
                    .offset(x: dark ? 21 : -21, y: dark ? 21 : -21)
            }
        }.frame(width: 52, height: 52).accessibilityHidden(true)
    }
}
