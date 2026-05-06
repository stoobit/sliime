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
 
 constant simd_float2 *center [[ buffer(InputBufferIndexForCenter) ]],
 constant float *scale [[ buffer(InputBufferIndexForScale) ]],
 constant float *degrees [[ buffer(InputBufferIndexForRotation) ]],
 
 constant simd_uint2 *viewPortSizePointer [[ buffer(InputBufferIndexForViewportSize) ]]
 )
{
    RasterizerData out;
    
    simd_float2 localPosition = vertexData[vertexID].position.xy;
    simd_float2 scaledPosition = *scale * localPosition;
    
    float radians = *degrees * (M_PI_F / 180.0);
    float cosR = cos(radians);
    float sinR = sin(radians);
    
    simd_float2 rotatedPosition = float2(
        scaledPosition.x * cosR - scaledPosition.y * sinR,
        scaledPosition.x * sinR + scaledPosition.y * cosR
    );
    
    simd_float2 globalPosition = rotatedPosition + center->xy;
    simd_float2 viewportSize = simd_float2(*viewPortSizePointer);
    out.position.xy = globalPosition / (viewportSize / 2.0);
    
    out.position.z = 0.0;
    out.position.w = 1.0;

    out.color = vertexData[vertexID].color;
    
    return out;
}

fragment float4 basic_fragment(RasterizerData in [[ stage_in ]]) {
    return in.color;
}
