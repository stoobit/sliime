//
//  CGSize.swift
//  sliime
//
//  Created by Till Brügmann on 04.05.26.
//

import Foundation

extension CGSize {
    public var simd_uint2: simd_uint2 {
        return simd.simd_uint2(UInt32(self.width), UInt32(self.height))
    }
    
    public var simd_float2: simd_float2 {
        return simd.simd_float2(Float(self.width), Float(self.height))
    }
}
