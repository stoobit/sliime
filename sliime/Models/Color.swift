//
//  Color.swift
//  sliime
//
//  Created by Till Brügmann on 06.05.26.
//

import UIKit

enum Color {
    static var red: SIMD4<Float> = color(for: .systemRed)
    static var blue: SIMD4<Float> = color(for: .systemBlue)
    static var green: SIMD4<Float> = color(for: .systemGreen)
    
    static func color(for color: UIColor) -> SIMD4<Float> {
        var (red, green, blue, alpha) = (CGFloat(), CGFloat(), CGFloat(), CGFloat())
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        
        return simd_float4(Float(red), Float(green), Float(blue), Float(alpha))
    }
}
