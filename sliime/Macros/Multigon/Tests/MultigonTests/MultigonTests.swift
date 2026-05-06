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
            struct Triangle: Renderable {
                var center: SIMD3<Float> = [0, 0, 0]

                var scale: Float
                var rotation: Float = 0

                var vertices: InlineArray<4, Vertex> = [
                    Vertex(position: simd_float2(-1.0, 1.0), color: white),
                    Vertex(position: simd_float2(1.0, -1.0), color: white),
                    Vertex(position: simd_float2(-1.0, -1.0), color: white),
                    Vertex(position: simd_float2(1.0, 1.0), color: white)
                ]
            
                mutating func render(using renderEncoder: any MTLRenderCommandEncoder) {
                    renderEncoder.setVertexBytes(
                        &vertices,
                        length: MemoryLayout.stride(ofValue: vertices),
                        index: Int(InputBufferIndexForVertexData.rawValue)
                    )

                    renderEncoder.setVertexBytes(
                        &center,
                        length: MemoryLayout.stride(ofValue: center),
                        index: Int(InputBufferIndexForCenter.rawValue)
                    )

                    renderEncoder.setVertexBytes(
                        &scale,
                        length: MemoryLayout.stride(ofValue: scale),
                        index: Int(InputBufferIndexForScale.rawValue)
                    )

                    renderEncoder.setVertexBytes(
                        &rotation,
                        length: MemoryLayout.stride(ofValue: rotation),
                        index: Int(InputBufferIndexForRotation.rawValue)
                    )

                    renderEncoder.drawPrimitives(
                        type: .triangleStrip, vertexStart: 0, vertexCount: 4
                    )
                }
            }
            """,
            macros: testMacros
        )
#else
        throw XCTSkip("macros are only supported when running tests for the host platform")
#endif
    }
}
