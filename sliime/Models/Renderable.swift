//
//  Renderable.swift
//  sliime
//
//  Created by Till Brügmann on 06.05.26.
//

import Metal
import Foundation

protocol Renderable {
    var position: SIMD3<Float> { get set }
    var velocity: SIMD3<Float> { get set }
    var acceleration: SIMD3<Float> { get set }
    
    var scale: Float { get set }
    var rotation: Float { get set }
    
    var restitution: Float { get set }
    
    var hitbox: SIMD4<Float> { get }
    
    mutating func render(using renderEncoder: any MTLRenderCommandEncoder)
}

extension Renderable {
    func position(x: Float = 0, y: Float = 0, z: Float = 0) -> Self {
        var copy = self
        copy.position = simd_float3(x, y, z)
        return copy
    }
    
    func velocity(x: Float = 0, y: Float = 0, z: Float = 0) -> Self {
        var copy = self
        copy.velocity = simd_float3(x, y, z)
        return copy
    }
    
    func acceleration(x: Float = 0, y: Float = 0, z: Float = 0) -> Self {
        var copy = self
        copy.acceleration = simd_float3(x, y, z)
        return copy
    }
    
    func scale(_ value: Float) -> Self {
        var copy = self
        copy.scale = value
        return copy
    }
    
    func rotation(_ value: Float) -> Self {
        var copy = self
        copy.rotation = value
        return copy
    }
    
    func restitution(_ value: Float) -> Self {
        var copy = self
        copy.restitution = value
        return copy
    }
}

extension SIMD4<Float> {
    var minX: Float { return self.x }
    var maxX: Float { return self.y }
    var minY: Float { return self.z }
    var maxY: Float { return self.w }
}
