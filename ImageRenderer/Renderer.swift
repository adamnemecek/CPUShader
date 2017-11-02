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
    func pixel(for point : float2) -> Pixel
}

struct CircleRenderer : Renderer {
    let uv : float2

    init(rect : CGRect) {
        uv = float2(cg: rect.center)
    }

    func pixel(for point : float2) -> Pixel {

        if distance(uv, point) < 10 {
            return Pixel(r: 0, g: 0, b: 0)
        }
        return Pixel(r: 0, g: 255, b: 255)
    }
}


class RenderableImage<R : Renderer> {
    let image : NSImage

    init(rect: CGRect) {
        let renderer = R(rect: rect)

        image = NSImage(size: rect.size) {
            renderer.pixel(for: $0)
        }
    }

}
