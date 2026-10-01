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
let catalog = root.appendingPathComponent("App/Resources/Assets.xcassets")
let assets = catalog.appendingPathComponent("AppIcon.appiconset")
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
    Palette(name: "AppIcon", background: 0x4F624A, line: 0xEDE8DD,
            lightStone: 0xFFF9ED, darkStone: 0x263337, darkEdge: 0xEDE8DD),
    Palette(name: "AppIcon-Dark", background: 0x171D20, line: 0xADBF9F,
            lightStone: 0xF1E9D9, darkStone: 0x263337, darkEdge: 0xADBF9F),
    Palette(name: "AppIcon-Tinted", background: 0x161616, line: 0xC4C4C4,
            lightStone: 0xF5F5F5, darkStone: 0x343434, darkEdge: 0xC4C4C4)
]

func context(width: Int, height: Int) -> CGContext {
    CGContext(data: nil, width: width, height: height, bitsPerComponent: 8,
              bytesPerRow: width * 4, space: space,
              bitmapInfo: CGImageAlphaInfo.noneSkipLast.rawValue)!
}
// A softly rounded Morris board, turned into a diamond. The two opposing
// stones leave clear gaps in the board, so the silhouette also works at 29 pt.
// This single geometry renders both the app icons and scalable in-app layers.
let stoneOffset: CGFloat = 295 * sqrt(2)
let lightCenter = CGPoint(x: 512, y: 512 + stoneOffset)
let darkCenter = CGPoint(x: 512, y: 512 - stoneOffset)
func circle(at point: CGPoint, radius: CGFloat) -> CGRect {
    CGRect(x: point.x - radius, y: point.y - radius, width: radius * 2, height: radius * 2)
}
func drawBoard(_ ctx: CGContext, ink: CGColor) {
    ctx.saveGState()
    let mask = CGMutablePath()
    mask.addRect(CGRect(x: 0, y: 0, width: 1024, height: 1024))
    for point in [lightCenter, darkCenter] { mask.addEllipse(in: circle(at: point, radius: 98)) }
    ctx.addPath(mask)
    ctx.clip(using: .evenOdd)
    ctx.translateBy(x: 512, y: 512)
    ctx.rotate(by: .pi / 4)
    ctx.setStrokeColor(ink)
    ctx.setLineWidth(30)
    ctx.setLineJoin(.round)
    ctx.setLineCap(.round)
    for (halfSide, radius): (CGFloat, CGFloat) in [(295, 52), (192, 38), (89, 22)] {
        let rect = CGRect(x: -halfSide, y: -halfSide, width: halfSide * 2, height: halfSide * 2)
        ctx.addPath(CGPath(roundedRect: rect, cornerWidth: radius, cornerHeight: radius, transform: nil))
        ctx.strokePath()
    }
    for (x1, y1, x2, y2): (CGFloat, CGFloat, CGFloat, CGFloat) in [
        (0, -295, 0, -89), (0, 89, 0, 295),
        (-295, 0, -89, 0), (89, 0, 295, 0)
    ] {
        ctx.move(to: CGPoint(x: x1, y: y1)); ctx.addLine(to: CGPoint(x: x2, y: y2)); ctx.strokePath()
    }
    ctx.restoreGState()
}
func drawRing(_ ctx: CGContext, center: CGPoint, outer: CGFloat, inner: CGFloat, ink: CGColor) {
    ctx.setFillColor(ink)
    ctx.addEllipse(in: circle(at: center, radius: outer))
    ctx.addEllipse(in: circle(at: center, radius: inner))
    ctx.drawPath(using: .eoFill)
}
func drawMark(_ ctx: CGContext, line: CGColor, lightStone: CGColor, darkStone: CGColor, darkEdge: CGColor) {
    drawBoard(ctx, ink: line)
    ctx.setFillColor(lightStone)
    ctx.fillEllipse(in: circle(at: lightCenter, radius: 76))
    ctx.setFillColor(darkStone)
    ctx.fillEllipse(in: circle(at: darkCenter, radius: 58))
    drawRing(ctx, center: darkCenter, outer: 76, inner: 58, ink: darkEdge)
}
func drawIcon(_ ctx: CGContext, palette: Palette) {
    ctx.setFillColor(color(palette.background))
    ctx.fill(CGRect(x: 0, y: 0, width: 1024, height: 1024))
    ctx.saveGState()
    ctx.translateBy(x: 512, y: 512)
    ctx.scaleBy(x: 0.78, y: 0.78)
    ctx.translateBy(x: -512, y: -512)
    drawMark(ctx, line: color(palette.line), lightStone: color(palette.lightStone),
             darkStone: color(palette.darkStone), darkEdge: color(palette.darkEdge))
    ctx.restoreGState()
}

// PDF templates retain vector data and transparency. SwiftUI tints the board
// with the selected accent and the second stone with semantic Ink.
func writeTemplate(name: String, draw: (CGContext) -> Void) throws {
    let directory = catalog.appendingPathComponent(name + ".imageset")
    try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
    var box = CGRect(x: 0, y: 0, width: 52, height: 52)
    let ctx = CGContext(directory.appendingPathComponent(name + ".pdf") as CFURL, mediaBox: &box, nil)!
    ctx.beginPDFPage(nil)
    ctx.scaleBy(x: 52 / 1024, y: 52 / 1024)
    draw(ctx)
    ctx.endPDFPage()
    ctx.closePDF()
    let contents: [String: Any] = [
        "images": [["filename": name + ".pdf", "idiom": "universal"]],
        "info": ["version": 1, "author": "xcode"],
        "properties": ["preserves-vector-representation": true, "template-rendering-intent": "template"]
    ]
    try JSONSerialization.data(withJSONObject: contents, options: [.prettyPrinted, .sortedKeys])
        .write(to: directory.appendingPathComponent("Contents.json"))
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
try writeTemplate(name: "BrandBoard") { ctx in
    drawBoard(ctx, ink: color(0x000000))
    ctx.setFillColor(color(0x000000))
    ctx.fillEllipse(in: circle(at: lightCenter, radius: 76))
    drawRing(ctx, center: darkCenter, outer: 76, inner: 58, ink: color(0x000000))
}
try writeTemplate(name: "BrandStone") { ctx in
    ctx.setFillColor(color(0x000000))
    ctx.fillEllipse(in: circle(at: darkCenter, radius: 58))
}
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
label("Waldgrün · Mühle als Signet", x: 54, y: 562, size: 19, ink: 0x596460)
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
print("Generated two vector logo layers, three opaque sRGB icons (1024 × 1024) and review sheet.")
