//
//  ViewController.swift
//  ImageRenderer
//
//  Created by Adam Nemecek on 11/2/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import Cocoa
import simd

/*
 float roundedFrame (float2 pos, float2 uv, float2 size, float radius, float thickness) {
 float d = length(max(abs(uv - pos),size) - size) - radius;
 return smoothstep(0.55, 0.45, abs(d / thickness) * 5.0);
 }
 */

extension CGRect {
    var center : CGPoint {
        return .init(x: midX, y: midY)
    }
}

extension float2 {
    init(cg : CGPoint) {
        self.init(Float(cg.x), Float(cg.y))
    }
}

class ViewController: NSViewController {
    @IBOutlet weak var imageView: NSImageView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let r = RenderableImage<CircleRenderer>(rect: view.bounds)

//        let img = NSImage(size: view.bounds.size) { p in
//
//            if distance(uv, p) < 10 {
//                return Pixel(r: 0, g: 0, b: 0)
//            }
//            return Pixel(r: 0, g: 255, b: 255)
//        }

        imageView.image = r.image
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

