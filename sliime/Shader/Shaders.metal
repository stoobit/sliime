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
 constant simd_uint2 *viewPortSizePointer [[ buffer(InputBufferIndexForViewportSize) ]],
 constant float *time [[ buffer(InputBufferIndexForTime) ]],
 constant float *gravity [[ buffer(InputBufferIndexForGravity) ]]
 )
{
    RasterizerData out;
    
    simd_float2 pixelSpacePosition = vertexData[vertexID].position.xy;
    simd_float2 viewportSize = simd_float2(*viewPortSizePointer);
    
    float g = 981.0 * 2;
    float position = -0.5 * g * pow(*time, 2) * *gravity;
    
    float offset = 350 - pixelSpacePosition.y;
    float minimum = -viewportSize.y * 0.5 + (250 - offset) * *gravity;
    
    pixelSpacePosition.y = max(position + pixelSpacePosition.y, minimum);
    out.position.xy = pixelSpacePosition / (viewportSize / 2.0);
    
    out.position.z = 0.0;
    out.position.w = 1.0;

    out.color = vertexData[vertexID].color;
    
    return out;
}

fragment float4 basic_fragment(RasterizerData in [[ stage_in ]]) {
    return in.color;
}
