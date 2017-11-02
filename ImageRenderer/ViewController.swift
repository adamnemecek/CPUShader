//
//  ViewController.swift
//  ImageRenderer
//
//  Created by Adam Nemecek on 11/2/17.
//  Copyright © 2017 Adam Nemecek. All rights reserved.
//

import Cocoa

extension NSImage {
    
}

class ViewController: NSViewController {
    @IBOutlet weak var imageView: NSImageView!

    override func viewDidLoad() {
        super.viewDidLoad()


        let img = NSImage.from(width: 100, height: 100) { _ in
            return Pixel(r: 0, g: 255, b: 255)
        }

        imageView.image = img
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

