package extra

//Gradient to get colors lineraly or constantly based off a sample point
//Code copied from godot, original license:

// Copyright (c) 2014-present Godot Engine contributors (see AUTHORS.md).
// Copyright (c) 2007-2014 Juan Linietsky, Ariel Manzur.

// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:

// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.

// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.

import rl "vendor:raylib"

//A point that represents a color and an percentage offset
ColorPoint :: struct {
	color:  rl.Color,
	offset: f32,
}

//A collection of colors and points to represent a gradient
//Create via `make(Gradient)`, destroy via `delete`
//Append ColorPoints and make sure the offsets are in order!
Gradient :: distinct [dynamic]ColorPoint

GradientAddPoint :: proc(gradient: ^Gradient, color: rl.Color, offset: f32) {
	append(gradient, ColorPoint{color = color, offset = offset})
}

//Samples gradient linearly, resulting in blended colors
GradientSampleLinear :: proc(gradient: Gradient, samplePoint: f32) -> rl.Color {
	low, middle := 0, 0
	high := len(gradient) - 1

	assert(low <= high)

	for low <= high {
		middle = (low + high) / 2
		point := &gradient[middle]
		if (point.offset > samplePoint) {
			high = middle - 1 //search low end of array
		} else if (point.offset < samplePoint) {
			low = middle + 1 //search high end of array
		} else {
			return point.color
		}
	}

	if gradient[middle].offset > samplePoint {
		middle -= 1
	}
	first := middle
	second := middle + 1
	if second >= len(gradient) {
		return gradient[len(gradient) - 1].color
	}
	if (first < 0) {
		return gradient[0].color
	}
	point1 := &gradient[first]
	point2 := &gradient[second]
	weight := (samplePoint - point1.offset) / (point2.offset - point1.offset)


	color1 := point1.color
	color2 := point2.color

	interpolated := rl.ColorLerp(color1, color2, weight)
	return interpolated
}

//Samples gradient linearly, resulting in an instant single color
GradientSampleConstant :: proc(gradient: Gradient, samplePoint: f32) -> rl.Color {
	low, middle := 0, 0
	high := len(gradient) - 1

	assert(low <= high)

	for low <= high {
		middle = (low + high) / 2
		point := &gradient[middle]
		if (point.offset > samplePoint) {
			high = middle - 1 //search low end of array
		} else if (point.offset < samplePoint) {
			low = middle + 1 //search high end of array
		} else {
			return point.color
		}
	}

	if gradient[middle].offset > samplePoint {
		middle -= 1
	}
	first := middle
	second := middle + 1
	if second >= len(gradient) {
		return gradient[len(gradient) - 1].color
	}
	if (first < 0) {
		return gradient[0].color
	}
	point1 := &gradient[first]

	return point1.color
}
