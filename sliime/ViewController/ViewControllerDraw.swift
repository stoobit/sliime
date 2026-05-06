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
        var triangle = Shapes.Triangle(scale: 300)
        triangle.center.y += 500
        triangle.render(using: renderEncoder)
        
        var square = Shapes.Square(scale: 300)
        square.render(using: renderEncoder)
        
        var hexagon = Shapes.Hexagon(scale: 300)
        hexagon.center.y -= 500
        hexagon.render(using: renderEncoder)
        
        // FINISH
        renderEncoder.endEncoding()
        commandBuffer.present(drawable)
        
        commandBuffer.commit()
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
       
    } 
}
