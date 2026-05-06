//
//  ViewController.swift
//  sliime
//
//  Created by Till Brügmann on 02.05.26.
//

import UIKit
import SwiftUI
import MetalKit

class ViewController: UIViewController {
    var mtkView: MTKView!
    var viewportSize: CGSize = .zero
    
    var commandQueue: MTLCommandQueue!
    var pipelineState: MTLRenderPipelineState?
    
    var renderable: [Renderable] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(
            self, selector: #selector(handle(_:)),
            name: .startTimer, object: nil
        )
        
        displayLinkSetup()
        metalSetup()
        viewSetup()
        
        initial()
    }
    
    func metalSetup() {
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
        pipelineStateDescriptor.colorAttachments[0].isBlendingEnabled = true
        
        Task {
            pipelineState = try await mtkView.device!
                .makeRenderPipelineState(descriptor: pipelineStateDescriptor)
        }
    }
    
    func viewSetup() {
        let hostingController = UIHostingController(rootView: ViewControllerView())
        hostingController.view.backgroundColor = .clear
        
        hostingController.view.frame = self.view.bounds
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        addChild(hostingController)
        
        self.view.addSubview(hostingController.view)
        hostingController.didMove(toParent: self)
    }
    
    func displayLinkSetup() {
        let displayLink = CADisplayLink(target: self, selector: #selector(update))
        displayLink.add(to: .main, forMode: .default)
    }
    
    @objc private func handle(_ notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            let timerState = userInfo[TimerState.Key] as? TimerState
        else { return }
        
        switch timerState {
        case .on:
            return
        case .off:
            return
        }
    }
}
