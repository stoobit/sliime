//
//  Renderable.swift
//  sliime
//
//  Created by Till Brügmann on 06.05.26.
//

import Metal
import Foundation

protocol Renderable {
    var center: SIMD3<Float> { get set }
    var scale: Float { get set }
    var rotation: Float { get set }
    
    mutating func render(using renderEncoder: any MTLRenderCommandEncoder)
}
