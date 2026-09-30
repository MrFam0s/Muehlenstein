import AppKit
let size = 1024
let bitmap = NSBitmapImageRep(bitmapDataPlanes: nil, pixelsWide: size, pixelsHigh: size, bitsPerSample: 8, samplesPerPixel: 3, hasAlpha: false, isPlanar: false, colorSpaceName: .deviceRGB, bytesPerRow: 0, bitsPerPixel: 0)!
NSGraphicsContext.saveGraphicsState()
NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: bitmap)
NSColor(red: 0.965, green: 0.953, blue: 0.922, alpha: 1).setFill()
NSBezierPath(rect: NSRect(x: 0, y: 0, width: size, height: size)).fill()
let ink = NSColor(red: 0.09, green: 0.41, blue: 0.37, alpha: 1)
ink.setStroke()
for inset in [210, 315, 420] {
    let path = NSBezierPath(rect: NSRect(x: inset, y: inset, width: 1024 - 2 * inset, height: 1024 - 2 * inset))
    path.lineWidth = 13; path.lineJoinStyle = .round; path.stroke()
}
for (start, end) in [(NSPoint(x: 512,y:210),NSPoint(x:512,y:420)), (NSPoint(x:512,y:604),NSPoint(x:512,y:814)), (NSPoint(x:210,y:512),NSPoint(x:420,y:512)), (NSPoint(x:604,y:512),NSPoint(x:814,y:512))] {
    let path=NSBezierPath();path.move(to:start);path.line(to:end);path.lineWidth=13;path.stroke()
}
for (point, color) in [(NSPoint(x:210,y:814),ink),(NSPoint(x:814,y:210),NSColor(red:0.16,green:0.2,blue:0.21,alpha:1))] {
    NSColor(red:0.965,green:0.953,blue:0.922,alpha:1).setFill()
    NSBezierPath(ovalIn:NSRect(x:point.x-70,y:point.y-70,width:140,height:140)).fill()
    color.setFill();NSBezierPath(ovalIn:NSRect(x:point.x-54,y:point.y-54,width:108,height:108)).fill()
}
NSGraphicsContext.restoreGraphicsState()
let output=URL(fileURLWithPath:CommandLine.arguments[1])
try bitmap.representation(using:.png,properties:[:])!.write(to:output)
