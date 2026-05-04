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
        
        guard let pipelineState = pipelineState,
              let drawable = view.currentDrawable,
              let descriptor = view.currentRenderPassDescriptor,
              let commandBuffer = commandQueue.makeCommandBuffer(),
              let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor)
        else { return }
        
        renderEncoder.setRenderPipelineState(pipelineState)
        
        viewportSize.x = UInt32(view.drawableSize.width)
        viewportSize.y = UInt32(view.drawableSize.height)
        
        var triangleData = configureTriangle()
        renderEncoder.setVertexBytes(
            &triangleData,
            length: MemoryLayout.stride(ofValue: triangleData),
            index: Int(InputBufferIndexForVertexData.rawValue)
        )
        
        var time: Float = 0
        if let startTime {
            time = Float(CACurrentMediaTime() - startTime)
        }
        
        renderEncoder.setVertexBytes(
            &time,
            length: MemoryLayout.stride(ofValue: time),
            index: Int(InputBufferIndexForTime.rawValue)
        )
        
        renderEncoder.setVertexBytes(
            &viewportSize,
            length: MemoryLayout.stride(ofValue: viewportSize),
            index:  Int(InputBufferIndexForViewportSize.rawValue)
        )
        
        renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
        renderEncoder.endEncoding()
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
       
    } 
}
