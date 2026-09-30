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
            .fill(side == 0 ? Color(red: 0.95, green: 0.92, blue: 0.86).gradient : Color(red: 0.17, green: 0.21, blue: 0.23).gradient)
            .overlay { Circle().strokeBorder(side == 0 ? Color.black.opacity(0.24) : Color.white.opacity(0.22), lineWidth: 1) }
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
            .opacity(configuration.isPressed ? 0.75 : 1)
    }
}
struct BrandMark: View {
    var body: some View {
        ZStack {
            ForEach(0..<3) { index in
                Rectangle().stroke(Color.petrol, lineWidth: 1.8).padding(CGFloat(index) * 8 + 4)
            }
            Rectangle().fill(Color.petrol).frame(width: 1.8).padding(.vertical, 4)
            Rectangle().fill(Color.limestone).frame(width: 12, height: 12)
            Circle().fill(Color.petrol).frame(width: 9, height: 9).offset(x: -22, y: -22)
            Circle().fill(Color.ink).frame(width: 9, height: 9).offset(x: 22, y: 22)
        }.frame(width: 52, height: 52).accessibilityHidden(true)
    }
}
