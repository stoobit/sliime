//
//  Multigon.swift
//  sliime
//
//  Created by Till Brügmann on 05.05.26.
//

import Foundation

@freestanding(declaration, names: arbitrary)
public macro Multigon(_ name: String, @VertexBuilder content: () -> [Vertex]) = #externalMacro(
    module: "MultigonMacros", type: "MultigonMacro"
)

@resultBuilder
struct VertexBuilder {
    static func buildBlock(_ components: Vertex...) -> [Vertex] {
        return components
    }
}
