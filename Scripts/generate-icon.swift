// SPDX-License-Identifier: AGPL-3.0-or-later
// Original vector artwork. Run: swift Scripts/generate-icon.swift
// Core Graphics renders into an explicit RGB bitmap; the former three-channel
// AppKit bitmap silently produced a black image on the development machine.
import Foundation
import CoreGraphics
import CoreText
import ImageIO
import UniformTypeIdentifiers

let root = URL(fileURLWithPath: #filePath).deletingLastPathComponent().deletingLastPathComponent()
let assets = root.appendingPathComponent("App/Resources/Assets.xcassets/AppIcon.appiconset")
let previews = root.appendingPathComponent("Docs/Previews")
let space = CGColorSpace(name: CGColorSpace.sRGB)!

func color(_ hex: UInt32) -> CGColor {
    CGColor(colorSpace: space, components: [CGFloat((hex >> 16) & 255) / 255,
        CGFloat((hex >> 8) & 255) / 255, CGFloat(hex & 255) / 255, 1])!
}
struct Palette {
    let name: String
    let background: UInt32
    let line: UInt32
    let lightStone: UInt32
    let darkStone: UInt32
    let darkEdge: UInt32
}
let palettes = [
    Palette(name: "AppIcon", background: 0x175B53, line: 0xEDE8DD,
            lightStone: 0xFFF9ED, darkStone: 0x263337, darkEdge: 0xEDE8DD),
    Palette(name: "AppIcon-Dark", background: 0x172326, line: 0x8AD0BD,
            lightStone: 0xF1E9D9, darkStone: 0x263337, darkEdge: 0x8AD0BD),
    Palette(name: "AppIcon-Tinted", background: 0x161616, line: 0xC4C4C4,
            lightStone: 0xF5F5F5, darkStone: 0x343434, darkEdge: 0xC4C4C4)
]

func context(width: Int, height: Int) -> CGContext {
    CGContext(data: nil, width: width, height: height, bitsPerComponent: 8,
              bytesPerRow: width * 4, space: space,
              bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)!
}
func drawIcon(_ ctx: CGContext, palette: Palette) {
    ctx.setFillColor(color(palette.background))
    ctx.fill(CGRect(x: 0, y: 0, width: 1024, height: 1024))
    ctx.setStrokeColor(color(palette.line))
    ctx.setLineWidth(26)
    ctx.setLineJoin(.round)
    ctx.setLineCap(.round)
    // A real Morris board: three squares, connected at the four side midpoints.
    for inset: CGFloat in [220, 340, 460] {
        ctx.stroke(CGRect(x: inset, y: inset, width: 1024 - 2 * inset, height: 1024 - 2 * inset))
    }
    for (x1, y1, x2, y2): (CGFloat, CGFloat, CGFloat, CGFloat) in [
        (512, 220, 512, 460), (512, 564, 512, 804),
        (220, 512, 460, 512), (564, 512, 804, 512)
    ] {
        ctx.move(to: CGPoint(x: x1, y: y1)); ctx.addLine(to: CGPoint(x: x2, y: y2)); ctx.strokePath()
    }
    for (x, y, isLight): (CGFloat, CGFloat, Bool) in [(220, 804, true), (804, 220, false)] {
        // A clean gap separates each stone from the grid at small Home Screen sizes.
        ctx.setFillColor(color(palette.background))
        ctx.fillEllipse(in: CGRect(x: x - 96, y: y - 96, width: 192, height: 192))
        ctx.setFillColor(color(isLight ? palette.lightStone : palette.darkEdge))
        ctx.fillEllipse(in: CGRect(x: x - 76, y: y - 76, width: 152, height: 152))
        if !isLight {
            ctx.setFillColor(color(palette.darkStone))
            ctx.fillEllipse(in: CGRect(x: x - 58, y: y - 58, width: 116, height: 116))
        }
    }
}
func write(_ ctx: CGContext, to url: URL) throws {
    let image = ctx.makeImage()!
    let destination = CGImageDestinationCreateWithURL(url as CFURL, UTType.png.identifier as CFString, 1, nil)!
    CGImageDestinationAddImage(destination, image, nil)
    guard CGImageDestinationFinalize(destination) else { fatalError("PNG export failed: \(url.path)") }
    // Fail immediately on an empty/solid export instead of shipping an invisible icon.
    let bytes = image.dataProvider!.data! as Data
    let background = Array(bytes[0..<3])
    var different = 0
    for index in stride(from: 0, to: bytes.count, by: 4) {
        if Array(bytes[index..<(index + 3)]) != background { different += 1 }
    }
    precondition(different > ctx.width * ctx.height / 20, "Icon contains too little visible artwork")
}
try FileManager.default.createDirectory(at: assets, withIntermediateDirectories: true)
try FileManager.default.createDirectory(at: previews, withIntermediateDirectories: true)
for palette in palettes {
    let ctx = context(width: 1024, height: 1024)
    drawIcon(ctx, palette: palette)
    try write(ctx, to: assets.appendingPathComponent(palette.name + ".png"))
}
let entries: [[String: Any]] = palettes.enumerated().map { index, palette in
    var entry: [String: Any] = ["filename": palette.name + ".png", "idiom": "universal", "platform": "ios", "size": "1024x1024"]
    if index > 0 { entry["appearances"] = [["appearance": "luminosity", "value": index == 1 ? "dark" : "tinted"]] }
    return entry
}
try JSONSerialization.data(withJSONObject: ["images": entries, "info": ["version": 1, "author": "xcode"]], options: [.prettyPrinted, .sortedKeys])
    .write(to: assets.appendingPathComponent("Contents.json"))

// A review sheet only: corner masking belongs to iOS and is not baked into the assets.
let preview = context(width: 1080, height: 660)
preview.setFillColor(color(0xF6F3EB)); preview.fill(CGRect(x: 0, y: 0, width: 1080, height: 660))
func label(_ text: String, x: CGFloat, y: CGFloat, size: CGFloat, ink: UInt32 = 0x263337) {
    let attributes = [kCTFontAttributeName: CTFontCreateWithName("HelveticaNeue" as CFString, size, nil),
                      kCTForegroundColorAttributeName: color(ink)] as CFDictionary
    let line = CTLineCreateWithAttributedString(CFAttributedStringCreate(nil, text as CFString, attributes)!)
    preview.textPosition = CGPoint(x: x, y: y); CTLineDraw(line, preview)
}
label("Mühlenstein", x: 54, y: 596, size: 34)
label("Drei Quadrate. Zwei Steine.", x: 54, y: 562, size: 19, ink: 0x596460)
for (index, palette) in palettes.enumerated() {
    let x = CGFloat(54 + index * 342)
    for (side, dx, y): (CGFloat, CGFloat, CGFloat) in [(288, 0, 240), (60, 2, 112), (40, 88, 122), (29, 158, 127)] {
        preview.saveGState()
        let rect = CGRect(x: x + dx, y: y, width: side, height: side)
        preview.addPath(CGPath(roundedRect: rect, cornerWidth: side * 0.224, cornerHeight: side * 0.224, transform: nil))
        preview.clip()
        preview.translateBy(x: rect.minX, y: rect.minY); preview.scaleBy(x: side / 1024, y: side / 1024)
        drawIcon(preview, palette: palette)
        preview.restoreGState()
    }
    label(["Standard", "Dunkel", "Eingefärbt · Vorlage"][index], x: x, y: 205, size: 20)
    label("60 / 40 / 29 pt", x: x, y: 70, size: 15, ink: 0x596460)
}
try write(preview, to: previews.appendingPathComponent("App-Icon-Appearances.png"))
print("Generated three opaque sRGB icons (1024 × 1024) and review sheet.")
