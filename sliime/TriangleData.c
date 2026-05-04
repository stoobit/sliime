//
//  TriangleData.c
//  sliime
//
//  Created by Till Brügmann on 03.05.26.
//

#include "TriangleData.h"

const simd_float4 red = { 1.0, 0.0, 0.0, 1.0 };
const simd_float4 green = { 0.0, 1.0, 0.0, 1.0 };
const simd_float4 blue = { 0.0, 0.0, 1.0, 1.0 };

TriangleData configureTriangleData(void) {
    TriangleData triangleData;
    triangle(&triangleData);
    
    return triangleData;
}

void triangle(TriangleData *triangleData) {
    simd_float2 position0 = {  0.0,   300 };
    simd_float2 position1 = { -300,  -300 };
    simd_float2 position2 = {  300,  -300 };
    
    triangleData->vertex0.color = red;
    triangleData->vertex0.position = position0;
    
    triangleData->vertex1.color = green;
    triangleData->vertex1.position = position1;
    
    triangleData->vertex2.color = blue;
    triangleData->vertex2.position = position2;
}
