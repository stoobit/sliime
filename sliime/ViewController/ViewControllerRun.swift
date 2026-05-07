//
//  ViewControllerLink.swift
//  sliime
//
//  Created by Till Brügmann on 06.05.26.
//

import SwiftUI

extension ViewController {
    @objc func initial() {
        renderable = [
            
            Shapes.BlueCircle(scale: 300)
                .position(y: 500)
                .acceleration(y: -9.81 * 100),
            
            Shapes.RedCircle(scale: 300)
                .position(y: -500)
            
        ]
    }
    
    @objc func update(displaylink: CADisplayLink) {
        let time: Float = Float(displaylink.targetTimestamp - displaylink.timestamp)
        
        for index in 0..<renderable.count {
            let object = renderable[index]
            
            renderable[index].velocity.y += object.acceleration.y * time
            renderable[index].position.y += object.velocity.y * time
        }
        
        if renderable.indices.contains(1) {
            let one = renderable[0].hitbox
            let two = renderable[1].hitbox
            
            // is overlapping
            if (one.minX < two.maxX && two.minX < one.maxX && one.minY < two.maxY && two.minY < one.maxY) {
                print("Overlapping")
            } else {
                print("not")
            }
        }
    }
}
