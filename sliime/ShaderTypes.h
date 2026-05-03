//
//  ShaderTypes.h
//  sliime
//
//  Created by Till Brügmann on 03.05.26.
//

#ifndef ShaderTypes_h
#define ShaderTypes_h

#include <simd/simd.h>

typedef enum InputBufferIndex
{
    
    InputBufferIndexForVertexData = 0,
    InputBufferIndexForViewportSize = 1,
    
} InputBufferIndex;

typedef struct
{

    simd_float2 position;
    simd_float4 color;
    
} VertexData;

typedef struct
{
    
    VertexData vertex0;
    VertexData vertex1;
    VertexData vertex2;
    
} TriangleData;

#endif
