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
    
} VertexData;

typedef enum InputBufferIndex
{
    
    InputBufferIndexForVertexData = 0,
    InputBufferIndexForCenter = 1,
    InputBufferIndexForScale = 2,
    InputBufferIndexForRotation = 3,
    
    InputBufferIndexForViewportSize = 4,
    
} InputBufferIndex;

#endif
