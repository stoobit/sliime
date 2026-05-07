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
        
        let vertices = vertices(from: node)
        let isProcedural = vertices.first?.contains("Procedural") == true
        
        return [
            DeclSyntax(try StructDeclSyntax("struct \(raw: name): Renderable") {
                try VariableDeclSyntax("var position: SIMD3<Float> = [0, 0, 0]")
                try VariableDeclSyntax("var velocity: SIMD3<Float> = [0, 0, 0]")
                try VariableDeclSyntax("var acceleration: SIMD3<Float> = [0, 0, 0]")
                    .with(\.trailingTrivia, .newlines(2))
                
                try VariableDeclSyntax("var scale: Float")
                try VariableDeclSyntax("var rotation: Float = 0")
                    .with(\.trailingTrivia, .newlines(2))
                
                try VariableDeclSyntax("var hitbox: SIMD4<Float>") {
                    switch isProcedural {
                    case true:
                        "let position: SIMD4<Float> = [position.x, position.x, position.y, position.y]"
                        "return [-0.5, 0.5, -0.5, 0.5] * scale + position"
                    case false:
                        "let position: SIMD4<Float> = [position.x, position.x, position.y, position.y]"
                        "return \(raw: hitbox(using: vertices)) * scale + position"
                    }
                }
                
                let strings = isProcedural ? procedural(using: vertices) : calculate(using: vertices)
                let string = strings
                    .joined(separator: ",\n")
                    .trimmingCharacters(in: .whitespacesAndNewlines)
                
                try VariableDeclSyntax(
                    """
                    var vertices: InlineArray<\(raw: strings.count), VertexData> = [
                        \(raw: string)
                    ]
                    """
                )
                .with(\.leadingTrivia, .newlines(2))
                
                try FunctionDeclSyntax("mutating func render(using renderEncoder: any MTLRenderCommandEncoder)") {
                    let buffers = [
                        ("vertices", "InputBufferIndexForVertexData"),
                        ("position", "InputBufferIndexForCenter"),
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
                                type: .triangleStrip, vertexStart: 0, vertexCount: \(raw: strings.count)
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
    
    static private func vertices(from node: some FreestandingMacroExpansionSyntax) -> [String] {
        let statements = (node.trailingClosure!.statements as CodeBlockItemListSyntax)
            .map { $0 as CodeBlockItemSyntax }

        
        return statements.map { $0.description }
    }
    
    static private func procedural(using strings: [String]) -> [String] {
        guard let procedural = strings.first else {
            return []
        }
        
        let (edges, color) = parse(procedural: procedural)
        
        var zigzagIndices: [Int] = []
        var left = 0
        var right = edges - 1
        
        while left <= right {
            zigzagIndices.append(left)
            if left != right {
                zigzagIndices.append(right)
            }
            left += 1
            right -= 1
        }
        
        var array: [String] = []
        for i in zigzagIndices {
            let angle = Float(i) * (2.0 * .pi / Float(edges))
            let x = 0.5 * sin(angle)
            let y = 0.5 * cos(angle)
            
            array.append(
                "VertexData(position: simd_float2(\(x), \(y)), color: \(color))"
            )
        }
        
        return array
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
    
    static private func hitbox(using vertices: [String]) -> String {
        return "[0, 0, 0, 0]"
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
    
    static private func parse(procedural: String) -> (edges: Int, color: String) {
        let regex = /Procedural\(\s*edges:\s*(\d+)\s*,\s*color:\s*(.+)\)/
        
        guard let match = procedural.firstMatch(of: regex) else {
            fatalError("Invalid Procedural syntax.")
        }
        
        let edgesString = String(match.output.1)
        let colorString = String(match.output.2)
        
        guard let edges = Int(edgesString) else {
            fatalError("Edges must be an integer.")
        }
        
        return (edges: edges, color: colorString)
    }
}

@main
struct MultigonPlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        MultigonMacro.self,
    ]
}
