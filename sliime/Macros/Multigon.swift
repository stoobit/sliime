//
//  Multigon.swift
//  sliime
//
//  Created by Till Brügmann on 05.05.26.
//

import Foundation

@freestanding(declaration, names: arbitrary)
public macro Multigon(_ name: String, @VertexBuilder content: () -> [VertexData]) = #externalMacro(
    module: "MultigonMacros", type: "MultigonMacro"
)

@resultBuilder
struct VertexBuilder {
    static func buildBlock(_ components: VertexData...) -> [VertexData] {
        return components
    }
}
