//
//  ViewControllerLink.swift
//  sliime
//
//  Created by Till Brügmann on 06.05.26.
//

import UIKit

extension ViewController {
    @objc func initial() {
        var triangle = Shapes.Triangle(scale: 300)
        triangle.center.y += 500
        renderable.append(triangle)
        
        let square = Shapes.Square(scale: 300)
        renderable.append(square)
        
        var hexagon = Shapes.Hexagon(scale: 300)
        hexagon.center.y -= 500
        renderable.append(hexagon)
    }
    
    @objc func update(displaylink: CADisplayLink) {
        print(displaylink.targetTimestamp)
        renderable[0].center.y += 0.20
    }
}
