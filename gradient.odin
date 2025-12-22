package extra

import m "core:math"
import rl "vendor:raylib"

//A point that represents a color and an percentage offset
ColorPoint :: struct {
	color:  rl.Color,
	offset: f32,
}

//Create via `make(Gradient)`, destroy via `delete`
Gradient :: distinct [dynamic]ColorPoint

GradientSampleLinear :: proc(grad: Gradient, samplePoint: f32) -> rl.Color {
	low, middle := 0, 0
	high := len(grad) - 1

	assert(low <= high)

	for low <= high {
		middle = (low + high) / 2
		point := &grad[middle]
		if (point.offset > samplePoint) {
			high = middle - 1 //search low end of array
		} else if (point.offset < samplePoint) {
			low = middle + 1 //search high end of array
		} else {
			return point.color
		}
	}

	if grad[middle].offset > samplePoint {
		middle -= 1
	}
	first := middle
	second := middle + 1
	if second >= len(grad) {
		return grad[len(grad) - 1].color
	}
	if (first < 0) {
		return grad[0].color
	}
	point1 := &grad[first]
	point2 := &grad[second]
	weight := (samplePoint - point1.offset) / (point2.offset - point1.offset)


	color1 := point1.color
	color2 := point2.color

	interpolated := rl.ColorLerp(color1, color2, weight)
	return interpolated
}


GradientSampleConstant :: proc(grad: Gradient, samplePoint: f32) -> rl.Color {
	low, middle := 0, 0
	high := len(grad) - 1

	assert(low <= high)

	for low <= high {
		middle = (low + high) / 2
		point := &grad[middle]
		if (point.offset > samplePoint) {
			high = middle - 1 //search low end of array
		} else if (point.offset < samplePoint) {
			low = middle + 1 //search high end of array
		} else {
			return point.color
		}
	}

	if grad[middle].offset > samplePoint {
		middle -= 1
	}
	first := middle
	second := middle + 1
	if second >= len(grad) {
		return grad[len(grad) - 1].color
	}
	if (first < 0) {
		return grad[0].color
	}
	point1 := &grad[first]

	return point1.color
}
