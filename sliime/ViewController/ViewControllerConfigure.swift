//
//  ViewControllerTriangle.swift
//  sliime
//
//  Created by Till Brügmann on 04.05.26.
//

import Foundation

extension ViewController {
    func configureShapes() -> InlineArray<8, VertexData> {
        let floor = configureFloor()
        let box = configureBox()
        
        let combined: InlineArray<8, VertexData> = [
            floor[0], floor[1], floor[2], floor[3],
            box[0],   box[1],   box[2],   box[3]
        ]
        
        return combined
    }
    
    private func configureFloor() -> InlineArray<4, VertexData> {
        let white = simd_float4(1.0, 1.0, 1.0, 1.0)
        
        let viewportSize = viewportSize.simd_float2 * 0.5
        
        let vertexData: InlineArray<4, VertexData> = [
            VertexData(position: simd_float2(-viewportSize.x, 000 - viewportSize.y), color: white),
            VertexData(position: simd_float2(-viewportSize.x, 250 - viewportSize.y), color: white),
            VertexData(position: simd_float2( viewportSize.x, 000 - viewportSize.y), color: white),
            VertexData(position: simd_float2( viewportSize.x, 250 - viewportSize.y), color: white),
        ]

        return vertexData
    }
    
    private func configureBox() -> InlineArray<4, VertexData> {
        let red   = simd_float4(1.0, 0.0, 0.0, 1.0)
        let blue  = simd_float4(0.0, 0.0, 1.0, 1.0)
        let green = simd_float4(0.0, 1.0, 0.0, 1.0)
        
        let vertexData: InlineArray<4, VertexData> = [
            VertexData(position: simd_float2(-250,  250 + 600), color: red),
            VertexData(position: simd_float2( 250,  250 + 600), color: red),
            VertexData(position: simd_float2(-250, -250 + 600), color: blue),
            VertexData(position: simd_float2( 250, -250 + 600), color: green),
        ]
        
        return vertexData
    }
}
