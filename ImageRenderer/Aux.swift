//
//  Aux.swift
//  ImageRenderer
//
//  Created by Adam Nemecek on 11/2/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import Cocoa
import simd

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

    static func *(lhs: Pixel, rhs: Float) -> Pixel {
        return Pixel(r: UInt8(Float(lhs.r) * rhs),
                     g: UInt8(Float(lhs.g) * rhs),
                     b: UInt8(Float(lhs.b) * rhs))
    }
}

extension CGBitmapInfo {
    static let premultipliedFirst = CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue)
}


extension NSImage {

    typealias DataProvider = (float2) -> Pixel

    // http://blog.human-friendly.com/drawing-images-from-pixel-data-in-swift
    convenience init(width: Int, height: Int, pixels: [Pixel]) {
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()

        assert(pixels.count == Int(width * height))

        var data = pixels // Copy to mutable []
        guard let providerRef = CGDataProvider(data: NSData(bytes: &data, length: data.count * MemoryLayout<Pixel>.size))
            else { fatalError("no cg data provider") }

        guard let image = CGImage(width: width,
                                  height: height,
                                  bitsPerComponent: 8,
                                  bitsPerPixel: 32,
                                  bytesPerRow: width * MemoryLayout<Pixel>.size,
                                  space: rgbColorSpace,
                                  bitmapInfo: .premultipliedFirst,
                                  provider: providerRef,
                                  decode: nil,
                                  shouldInterpolate: true,
                                  intent: .defaultIntent) else { fatalError("Couldn't create CGImage") }
        self.init(cgImage: image, size: .zero)
    }

    convenience init(size: CGSize, pixels: DataProvider) {
        var p: [Pixel] = []
        let height = Int(size.height)
        let width = Int(size.width)

        for y in 0..<height {
            for x in 0..<width {
                p.append(pixels(.init(Float(x), Float(y))))
            }
        }

        self.init(width: width, height: height, pixels: p)
    }


    func saveAsJpg(to url: URL) {

        guard
            let imageData = tiffRepresentation,
            let bitmapImageRep = NSBitmapImageRep(data: imageData),
            let data = bitmapImageRep.representation(using: .jpeg,
                                                     properties: [.compressionFactor: 1.0])
            else { return }
        try? data.write(to: url, options: [])
    }
}
