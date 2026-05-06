//
//  ViewControllerDelegate.swift
//  sliime
//
//  Created by Till Brügmann on 04.05.26.
//

import UIKit
import MetalKit

extension ViewController: MTKViewDelegate {
    func draw(in view: MTKView) {
        // SETUP
        guard let pipelineState = pipelineState,
              let drawable = view.currentDrawable,
              let descriptor = view.currentRenderPassDescriptor,
              let commandBuffer = commandQueue.makeCommandBuffer(),
              let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor)
        else { return }
        
        renderEncoder.setRenderPipelineState(pipelineState)
        
        // VIEWPORT
        viewportSize.width = view.drawableSize.width
        viewportSize.height = view.drawableSize.height
        
        var viewportSize = viewportSize.simd_uint2
        renderEncoder.setVertexBytes(
            &viewportSize,
            length: MemoryLayout.stride(ofValue: viewportSize),
            index:  Int(InputBufferIndexForViewportSize.rawValue)
        )
        
        // SHAPES
        var triangle = Shape.Triangle(scale: 20)
        
        renderEncoder.setVertexBytes(
            &triangle.vertices,
            length: MemoryLayout.stride(ofValue: triangle.vertices),
            index: Int(InputBufferIndexForVertexData.rawValue)
        )
        
        renderEncoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 3)
        
        // FINISH
        renderEncoder.endEncoding()
        commandBuffer.present(drawable)
        
        commandBuffer.commit()
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
       
    } 
}
