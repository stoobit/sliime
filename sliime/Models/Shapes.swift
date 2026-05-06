//
//  Shape.swift
//  sliime
//
//  Created by Till Brügmann on 05.05.26.
//

import Metal
import Multigon
import Foundation

struct Shapes {
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
    
    #Multigon("Circle") {
        Procedural(edges: 100, color: Color.red)
    }
}
