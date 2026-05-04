//
//  ViewController.swift
//  sliime
//
//  Created by Till Brügmann on 02.05.26.
//

import UIKit
import MetalKit

class ViewController: UIViewController, MTKViewDelegate {
    var mtkView: MTKView!
    var viewportSize: simd_uint2 = .zero
    
    var commandQueue: MTLCommandQueue!
    var pipelineState: MTLRenderPipelineState?
    
    var startTime = CACurrentMediaTime()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Default Setup
        mtkView = MTKView(frame: self.view.bounds, device: MTLCreateSystemDefaultDevice())
        mtkView.delegate = self
        
        mtkView.clearColor = MTLClearColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0)
        
        mtkView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(mtkView)
        
        commandQueue = mtkView.device?.makeCommandQueue()
        
        let defaultLibrary = mtkView.device!.makeDefaultLibrary()!
        let fragmentProgram = defaultLibrary.makeFunction(name: "basic_fragment")
        let vertexProgram = defaultLibrary.makeFunction(name: "basic_vertex")
            
        let pipelineStateDescriptor = MTLRenderPipelineDescriptor()
        pipelineStateDescriptor.vertexFunction = vertexProgram
        pipelineStateDescriptor.fragmentFunction = fragmentProgram
        
        pipelineStateDescriptor.colorAttachments[0].pixelFormat = mtkView.colorPixelFormat
            
        Task {
            pipelineState = try await mtkView.device!
                .makeRenderPipelineState(descriptor: pipelineStateDescriptor)
        }
    }
    
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
       
    }
    
    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable,
              let descriptor = view.currentRenderPassDescriptor,
              let commandBuffer = commandQueue.makeCommandBuffer(),
              let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor),
              let pipelineState = pipelineState
        else { return }
        
        renderEncoder.setRenderPipelineState(pipelineState)
        
        viewportSize.x = UInt32(view.drawableSize.width)
        viewportSize.y = UInt32(view.drawableSize.height)
        
        var triangleData = configureTriangleData()
        renderEncoder.setVertexBytes(
            &triangleData,
            length: MemoryLayout.size(ofValue: triangleData),
            index: Int(InputBufferIndexForVertexData.rawValue)
        )
        
        var time: Float = Float(CACurrentMediaTime() - startTime)
        renderEncoder.setVertexBytes(
            &time,
            length: MemoryLayout.size(ofValue: time),
            index: Int(InputBufferIndexForTime.rawValue)
        )
        
        renderEncoder.setVertexBytes(
            &viewportSize,
            length: MemoryLayout.size(ofValue: viewportSize),
            index:  Int(InputBufferIndexForViewportSize.rawValue)
        )
        
        renderEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: 3)
        renderEncoder.endEncoding()
        
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
