//
//  Shape.swift
//  sliime
//
//  Created by Till Brügmann on 05.05.26.
//

import Foundation
import Multigon

struct Shape {
    
    #Multigon("Triangle") {
        VertexData(position: simd_float2( 0.0,  0.5), color: Color.red)
        VertexData(position: simd_float2( 0.5, -0.5), color: Color.red)
        VertexData(position: simd_float2(-0.5, -0.5), color: Color.red)
    }
    
}

enum Color {
    static let red   = simd_float4(1.0, 0.0, 0.0, 1.0)
    static let blue  = simd_float4(0.0, 0.0, 1.0, 1.0)
    static let green = simd_float4(0.0, 1.0, 0.0, 1.0)
}
