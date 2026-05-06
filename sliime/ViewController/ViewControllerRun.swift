//
//  ViewControllerLink.swift
//  sliime
//
//  Created by Till Brügmann on 06.05.26.
//

import UIKit

extension ViewController {
    @objc func initial() {
        renderable.removeAll()
        
        var triangle = Shapes.Triangle(scale: 300)
        triangle.position.y += 500
        renderable.append(triangle)
        
        let square = Shapes.Square(scale: 300)
        renderable.append(square)
        
        var hexagon = Shapes.Hexagon(scale: 300)
        hexagon.position.y -= 500
        renderable.append(hexagon)
    }
    
    @objc func update(displaylink: CADisplayLink) {
        guard let initialTime else { return }
        let delta: Float = Float(displaylink.targetTimestamp - initialTime)
        
        
        renderable[0].position.y -= 0.5 * 9.81 * pow(delta, 2)
        
        renderable[2].scale += sin(delta * 10) * 2
    }
}
