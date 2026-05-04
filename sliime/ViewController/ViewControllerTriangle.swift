//
//  ViewControllerTriangle.swift
//  sliime
//
//  Created by Till Brügmann on 04.05.26.
//

import Foundation

extension ViewController {
    func configureTriangle() -> InlineArray<3, VertexData> {
        let red   = simd_float4(1.0, 0.0, 0.0, 1.0)
        let blue  = simd_float4(0.0, 0.0, 1.0, 1.0)
        let green = simd_float4(0.0, 1.0, 0.0, 1.0)
        
        let vertexData: InlineArray<3, VertexData> = [
            VertexData(position: simd_float2( 0.0,  300), color: red),
            VertexData(position: simd_float2(-300, -300), color: blue),
            VertexData(position: simd_float2( 300, -300), color: green),
        ]
        
        return vertexData;
    }
}
