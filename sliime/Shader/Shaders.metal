//
//  Shaders.metal
//  sliime
//
//  Created by Till Brügmann on 02.05.26.
//

#include <metal_stdlib>
#include "ShaderTypes.h"

using namespace metal;

struct RasterizerData
{
 
    float4 position [[ position ]];
    float4 color;
    
};

vertex RasterizerData basic_vertex
(
 uint vertexID [[ vertex_id ]],
 constant VertexData *vertexData [[ buffer(InputBufferIndexForVertexData) ]],
 constant simd_uint2 *viewPortSizePointer [[ buffer(InputBufferIndexForViewportSize) ]]
 )
{
    RasterizerData out;
    
    simd_float2 pixelSpacePosition = vertexData[vertexID].position.xy;
    simd_float2 viewportSize = simd_float2(*viewPortSizePointer);
    
    out.position.xy = pixelSpacePosition / (viewportSize / 2.0);
    
    out.position.z = 0.0;
    out.position.w = 1.0;

    out.color = vertexData[vertexID].color;
    
    return out;
}

fragment float4 basic_fragment(RasterizerData in [[ stage_in ]]) {
    return in.color;
}
