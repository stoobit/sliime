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
        
        // TIME
        var time: Float = 0
        if let startTime {
            time = Float(CACurrentMediaTime() - startTime)
        }
        
        // SHAPES
        var triangleData = configureShapes()
        renderEncoder.setVertexBytes(
            &triangleData,
            length: MemoryLayout.stride(ofValue: triangleData),
            index: Int(InputBufferIndexForVertexData.rawValue)
        )
        
        renderEncoder.setVertexBytes(
            &time,
            length: MemoryLayout.stride(ofValue: time),
            index: Int(InputBufferIndexForTime.rawValue)
        )
        
        // GRAVITY
        var gravityMultiplier: Float = 0.0
        renderEncoder.setVertexBytes(
            &gravityMultiplier,
            length: MemoryLayout.stride(ofValue: gravityMultiplier),
            index: Int(InputBufferIndexForGravity.rawValue)
        )
        renderEncoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 4)
        
        gravityMultiplier = 1.0
        renderEncoder.setVertexBytes(
            &gravityMultiplier,
            length: MemoryLayout.stride(ofValue: gravityMultiplier),
            index: Int(InputBufferIndexForGravity.rawValue)
        )
        renderEncoder.drawPrimitives(type: .triangleStrip, vertexStart: 4, vertexCount: 4)
        
        // FINISH
        renderEncoder.endEncoding()
        commandBuffer.present(drawable)
        
        commandBuffer.commit()
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
       
    } 
}
