//
//  TriangleData.h
//  sliime
//
//  Created by Till Brügmann on 03.05.26.
//

#ifndef TriangleData_h
#define TriangleData_h

#include <stdio.h>
#include <simd/simd.h>

#include "ShaderTypes.h"

void triangle(double offset, TriangleData *triangleData);
TriangleData configureTriangleData(double elapsedTime);

#endif
