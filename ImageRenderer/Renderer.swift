//
//  Renderers.swift
//  ImageRenderer
//
//  Created by Adam Nemecek on 11/2/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import Foundation
import simd

protocol Renderer {
    init(size: CGSize)
    func pixel(for point : float2) -> Pixel
}
//
//struct CircleRenderer : Renderer {
////    let center : float2
//
//    init(size : CGSize) {
////        center =
//    }
//
//    func pixel(for point : float2) -> Pixel {
//
//    }
//}

