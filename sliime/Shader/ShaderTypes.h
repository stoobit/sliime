//
//  ShaderTypes.h
//  sliime
//
//  Created by Till Brügmann on 03.05.26.
//

#ifndef ShaderTypes_h
#define ShaderTypes_h

#include <simd/simd.h>

typedef struct
{

    simd_float2 position; // DO NOT MODIFY, EXCEPT: SIMD2 -> SIMD3
    simd_float4 color;
    
} Vertex;

typedef enum InputBufferIndex
{
    
    InputBufferIndexForVertexData = 0,
    InputBufferIndexForViewportSize = 1,
    InputBufferIndexForTime = 2,
    InputBufferIndexForGravity = 3,
    
} InputBufferIndex;

#endif
