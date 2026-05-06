//
//  Shape.swift
//  sliime
//
//  Created by Till Brügmann on 05.05.26.
//

import MetalKit
import Multigon
import Foundation

enum Color {
    static let red   = simd_float4(1.0, 0.0, 0.0, 1.0)
    static let blue  = simd_float4(0.0, 0.0, 1.0, 1.0)
    static let green = simd_float4(0.0, 1.0, 0.0, 1.0)
}

struct Shape {
    #Multigon("Triangle") {
        VertexData(position: simd_float2( 0.0,  0.5), color: Color.red)
        VertexData(position: simd_float2( 0.5, -0.5), color: Color.red)
        VertexData(position: simd_float2(-0.5, -0.5), color: Color.red)
    }
}

extension Shape.Triangle {
    mutating func render(using renderEncoder: any MTLRenderCommandEncoder) {
        renderEncoder.setVertexBytes(
            &vertices,
            length: MemoryLayout.stride(ofValue: vertices),
            index: Int(InputBufferIndexForVertexData.rawValue)
        )
        
        renderEncoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 3)
    }
}
