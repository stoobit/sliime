//
//  ViewControllerLink.swift
//  sliime
//
//  Created by Till Brügmann on 06.05.26.
//

import MetalKit

extension ViewController {
    @objc func initial() {
        let size: SIMD2<Float> = [
            Float(mtkView.drawableSize.width),
            Float(mtkView.drawableSize.height)
        ]
        
        renderable = [
            // FLOOR
            Shapes.Floor(scale: size.x / 2)
                .position(y: -size.y / 2 + 200),
            
            // OBJECTS
            Shapes.Object(scale: 300)
                .position(x: -size.x / 3, y: 500)
                .acceleration(y: -9.81 * 2000)
                .restitution(0.8),
            
            Shapes.Object(scale: 300)
                .position(y: 500)
                .acceleration(y: -9.81 * 2000)
                .restitution(0.5),
            
            Shapes.Object(scale: 300)
                .position(x: +size.x / 3, y: 500)
                .acceleration(y: -9.81 * 2000)
                .restitution(0.2),
        ]
    }
    
    @objc func update(displaylink: CADisplayLink) {
        let time: Float = Float(displaylink.targetTimestamp - displaylink.timestamp)
        
        guard renderable.indices.contains(1) else {
            return
        }
        
        let floor = renderable[0]
        
        for index in 1..<renderable.count {
            var object = renderable[index]
            
            object.velocity.y += object.acceleration.y * time
            object.position.y += object.velocity.y * time
            
            if isOverlapping(object, floor) {
                let overlap = floor.hitbox.maxY - object.hitbox.minY
                object.position.y += overlap
                object.velocity.y = -object.velocity.y * object.restitution
            }
            
            renderable[index] = object
        }
    }
    
    func isOverlapping(_ one: any Renderable, _ two: any Renderable) -> Bool {
        let (one, two) = (one.hitbox, two.hitbox)
        return one.minX < two.maxX && two.minX < one.maxX && one.minY < two.maxY && two.minY < one.maxY
    }
}
