//
//  Renderable.swift
//  sliime
//
//  Created by Till Brügmann on 06.05.26.
//

import Metal
import Foundation

protocol Renderable {
    mutating func render(using renderEncoder: any MTLRenderCommandEncoder)
}
