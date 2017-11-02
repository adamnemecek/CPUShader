//
//  Renderers.swift
//  ImageRenderer
//
//  Created by Adam Nemecek on 11/2/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import Cocoa
import simd

protocol Renderer {
    init(rect : CGRect)
    func pixel(for p : float2) -> Pixel
}

struct CircleRenderer : Renderer {
    let uv : float2
    let rect : CGRect

    init(rect : CGRect) {
        self.rect = rect
        uv = float2(cg: rect.center)
    }

    func pixel(for p: float2) -> Pixel {

        if distance(uv, p) < 10 {
            return Pixel(r: 0, g: 0, b: 0)
        }

        return Pixel(r: 0, g: 255, b: 255)
    }
}

struct RoundedRectRenderer : Renderer {
    let uv : float2
    let rect : CGRect

    init(rect : CGRect) {
        self.rect = rect
        uv = float2(cg: rect.center)
    }

    func pixel(for p : float2) -> Pixel {
        let s = rect.size
        let size = float2(Float(s.width), Float(s.height)) / 4
        let radius : Float = 5.0
        let thickness : Float = 10

        let d : Float = length(max(abs(uv - p), size) - size) - radius
        let i = simd_smoothstep(Float(0.55), Float(0.45), abs(d/thickness) * 5)

//        if distance(uv, p) < 10 {
//            return Pixel(r: 0, g: 0, b: 0)
//        }

        return Pixel(r: 0, g: 255, b: 255) * i
    }
}


class ImageRenderer<R : Renderer> {
    let image : NSImage

    init(rect: CGRect) {
        let renderer = R(rect: rect)

        image = NSImage(size: rect.size) {
            renderer.pixel(for: $0)
        }
    }

}

