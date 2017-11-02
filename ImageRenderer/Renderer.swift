//
//  Renderer.swift
//  ImageRenderer
//
//  Created by Adam Nemecek on 11/2/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import Cocoa

struct Pixel {
    var a: UInt8 = 255
    var r: UInt8
    var g: UInt8
    var b: UInt8


    init(r: UInt8, g: UInt8, b: UInt8) {
        self.r = r
        self.g = g
        self.b = b
    }
}


extension NSImage {

    // http://blog.human-friendly.com/drawing-images-from-pixel-data-in-swift
    static func from(width: Int, height: Int, pixels: [Pixel]) -> NSImage {
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let bitmapInfo: CGBitmapInfo = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)

        assert(pixels.count == Int(width * height))

        var data = pixels // Copy to mutable []
        guard
            let providerRef = CGDataProvider(data: NSData(bytes: &data, length: data.count * MemoryLayout<Pixel>.size))
            else { fatalError("no cg data provider") }

        guard let image = CGImage(width: width,
                                  height: height,
                                  bitsPerComponent: 8,
                                  bitsPerPixel: 32,
                                  bytesPerRow: width * MemoryLayout<Pixel>.size,
                                  space: rgbColorSpace,
                                  bitmapInfo: bitmapInfo,
                                  provider: providerRef,
                                  decode: nil,
                                  shouldInterpolate: true,
                                  intent: .defaultIntent) else { fatalError("Couldn't create CGImage") }
        return NSImage(cgImage: image, size: .zero)
    }

    static func from(size: CGSize, pixels: ((x: Int, y: Int)) -> Pixel) -> NSImage {
        var p: [Pixel] = []
        let height = Int(size.height)
        let width = Int(size.width)

        for x in 0..<width {
            for y in 0..<height {
                p.append(pixels((x, y)))
            }
        }

        return .from(width: width, height: height, pixels: p)
    }


    func saveAsJpg(to url: URL) {
        let options: [NSBitmapImageRep.PropertyKey: Any] = [.compressionFactor: 1.0]
        guard
            let imageData = tiffRepresentation,
            let bitmapImageRep = NSBitmapImageRep(data: imageData),
            let data = bitmapImageRep.representation(using: .jpeg, properties: options)
            else { return }
        try? data.write(to: url, options: [])
    }
}
