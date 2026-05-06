import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

#if canImport(MultigonMacros)
import MultigonMacros

let testMacros: [String: Macro.Type] = [
    "Multigon": MultigonMacro.self,
]
#endif

final class MultigonTests: XCTestCase {
    func test() throws {
#if canImport(MultigonMacros)
        assertMacroExpansion(
            """
            #Multigon("Triangle") {
                Vertex(position: simd_float2(-1.0, 1.0), color: white)
                Vertex(position: simd_float2(1.0, -1.0), color: white)
                Vertex(position: simd_float2(-1.0, -1.0), color: white)
                Vertex(position: simd_float2(1.0, 1.0), color: white)
            }
            """,
            expandedSource: """
            struct Triangle {
                var center: SIMD3<Float> = [0, 0, 0]

                var scale: Float
                var rotation: Float = 0
            
                init(scale: Float) {
                    self.scale = scale
                }

                var vertices: InlineArray<4, Vertex> = [
                    Vertex(position: simd_float2(-1.0, 1.0), color: white),
                    Vertex(position: simd_float2(1.0, -1.0), color: white),
                    Vertex(position: simd_float2(-1.0, -1.0), color: white),
                    Vertex(position: simd_float2(1.0, 1.0), color: white)
                ]
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }
}
