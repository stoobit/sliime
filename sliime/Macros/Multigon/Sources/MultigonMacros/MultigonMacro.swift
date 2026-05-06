import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros
import Foundation

public struct MultigonMacro: DeclarationMacro {
    public static func expansion(
        of node: some SwiftSyntax.FreestandingMacroExpansionSyntax,
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> [SwiftSyntax.DeclSyntax] {
        
        let name = name(from: node)
        let (type, vertices) = vertices(from: node)
        
        return [
            DeclSyntax(try StructDeclSyntax("struct \(raw: name): Renderable") {
                try VariableDeclSyntax("var center: SIMD3<Float> = [0, 0, 0]")
                    .with(\.trailingTrivia, .newlines(2))
                
                try VariableDeclSyntax("var scale: Float")
                try VariableDeclSyntax("var rotation: Float = 0")
                
                let string: String = calculate(using: vertices)
                    .joined(separator: ",")
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                
                try VariableDeclSyntax(
                    """
                    var vertices: InlineArray<\(raw: vertices.count), \(raw: type)> = [
                        \(raw: string)
                    ]
                    """
                )
                .with(\.leadingTrivia, .newlines(2))
                
                try FunctionDeclSyntax("mutating func render(using renderEncoder: any MTLRenderCommandEncoder)") {
                    let buffers = [
                        ("vertices", "InputBufferIndexForVertexData"),
                        ("center", "InputBufferIndexForCenter"),
                        ("scale", "InputBufferIndexForScale"),
                        ("rotation", "InputBufferIndexForRotation")
                    ]
                    
                    for (property, bufferIndex) in buffers {
                        ExprSyntax(
                                """
                                renderEncoder.setVertexBytes(
                                    &\(raw: property),
                                    length: MemoryLayout.stride(ofValue: \(raw: property)),
                                    index: Int(\(raw: bufferIndex).rawValue)
                                )
                                """
                        )
                        .with(\.trailingTrivia, .newlines(2))
                    }
                    
                    ExprSyntax(
                            """
                            renderEncoder.drawPrimitives(
                                type: .triangleStrip, vertexStart: 0, vertexCount: \(raw: vertices.count)
                            )
                            """
                        )
                }
                .with(\.leadingTrivia, .newlines(2))
            })
        ]
    }
    
    static private func name(from node: some FreestandingMacroExpansionSyntax) -> String {
        let expression = node.arguments.first?.expression.as(StringLiteralExprSyntax.self)!
        let segments = expression!.segments as StringLiteralSegmentListSyntax
        let segment = segments.first?.as(StringSegmentSyntax.self)
        let name = segment?.content.text
        
        return name ?? ""
    }
    
    static private func vertices(from node: some FreestandingMacroExpansionSyntax) -> (String, [String]) {
        let statements = (node.trailingClosure!.statements as CodeBlockItemListSyntax)
            .map { $0 as CodeBlockItemSyntax }
        
        let name = statements.first?
            .item.as(FunctionCallExprSyntax.self)?
            .calledExpression.as(DeclReferenceExprSyntax.self)?
            .baseName.identifier?.name
        
        guard let name else {
            fatalError("No base name for vertices found.")
        }
        
        return (name, statements.map { $0.description })
    }
    
    static private func calculate(using vertices: [String]) -> [String] {
        var vertices = vertices
        let points: [SIMD3<Double>] = vertices
            .map { parse(vertex: $0) }
        
        let center = points.reduce(.zero, +) / Double(points.count)
        
        for (index, point) in points.enumerated() {
            let string = vertices[index]
            let point = point - center
            
            vertices[index] = replace(in: string, using: point)
        }
        
        return vertices
    }
    
    static private func replace(in string: String, using point: SIMD3<Double>) -> String {
        return string
            .replacing(
                /simd_float2\([^)]*\)/,
                with: "simd_float2(\(point.x), \(point.y))"
            )
            .replacing(
                /simd_float3\([^)]*\)/,
                with: "simd_float3(\(point.x), \(point.y), \(point.z))"
            )
    }
    
    static private func parse(vertex: String) -> SIMD3<Double> {
        let regex = /position:\s*(?!position\b)[^()]+\(\s*([+-]?\d*\.?\d+)\s*,\s*([+-]?\d*\.?\d+)\s*(?:,\s*([+-]?\d*\.?\d+)\s*)?\)/
        
        guard let match = vertex.firstMatch(of: regex) else {
            fatalError("Missing or invalid 'position' argument. Each vertex must define 'position' as a simd_float2(x, y) or simd_float3(x, y, z).")
        }
        
        let (_, p1, p2, p3) = match.output
        
        let points: [Double] = [p1, p2, p3]
            .map { Double($0 ?? "-") ?? 0 }
        
        return SIMD3<Double>(points[0], points[1], points[2])
    }
}

@main
struct MultigonPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        MultigonMacro.self,
    ]
}
