//
//  Shape.swift
//  sliime
//
//  Created by Till Brügmann on 05.05.26.
//

import Metal
import Multigon
import Foundation

enum Color {
    static let red   = simd_float4(1.0, 0.0, 0.0, 1.0)
    static let blue  = simd_float4(0.0, 0.0, 1.0, 1.0)
    static let green = simd_float4(0.0, 1.0, 0.0, 1.0)
}

enum Shapes {
    #Multigon("Triangle") {
        VertexData(position: simd_float2( 0.0,  0.5), color: Color.red)
        VertexData(position: simd_float2( 0.5, -0.5), color: Color.red)
        VertexData(position: simd_float2(-0.5, -0.5), color: Color.red)
    }
    
    #Multigon("Square") {
        VertexData(position: simd_float2(-0.5, -0.5), color: Color.red)
        VertexData(position: simd_float2(-0.5,  0.5), color: Color.red)
        VertexData(position: simd_float2( 0.5, -0.5), color: Color.red)
        VertexData(position: simd_float2( 0.5,  0.5), color: Color.red)
    }
    
    #Multigon("Hexagon") {
        VertexData(position: simd_float2( 0.0,    0.50), color: Color.red)
        VertexData(position: simd_float2(-0.433,  0.25), color: Color.red)
        VertexData(position: simd_float2( 0.433,  0.25), color: Color.red)
        VertexData(position: simd_float2(-0.433, -0.25), color: Color.red)
        VertexData(position: simd_float2( 0.433, -0.25), color: Color.red)
        VertexData(position: simd_float2( 0.0,   -0.50), color: Color.red)
    }
}
