package extra

//This contains procs to help with setting and getting rect parts

import rl "vendor:raylib"

//Gets the left center of the rectangle
RectGetLeft :: proc(rect: rl.Rectangle) -> rl.Vector2 {
	x := rect.x
	return {x, 0}
}

//Sets the left of the rectangle
RectSetLeft :: proc(rect: ^rl.Rectangle, position: rl.Vector2) {
	rect.x = position.x
}

//Gets the right center of the rectangle
RectGetRight :: proc(rect: rl.Rectangle) -> rl.Vector2 {
	x := rect.x + rect.width
	return {x, 0}
}

//Sets the right of the rectangle
RectSetRight :: proc(rect: ^rl.Rectangle, position: rl.Vector2) {
	rect.x = position.x - rect.width
}

//Gets the top center of the rectangle
RectGetTop :: proc(rect: rl.Rectangle) -> rl.Vector2 {
	// x := rect.x + rect.width / 2
	y := rect.y
	return {0, y}
}

//Sets the top of the rectangle
RectSetTop :: proc(rect: ^rl.Rectangle, position: rl.Vector2) {
	rect.y = position.y
}

//Gets the bottom center of the rectangle
RectGetBottom :: proc(rect: rl.Rectangle) -> rl.Vector2 {
	y := rect.y + rect.height
	return {0, y}
}

//Sets the bottom of the rectangle
RectSetBottom :: proc(rect: ^rl.Rectangle, position: rl.Vector2) {
	rect.y = position.y - rect.height
}

GetCenterX :: proc(rect: rl.Rectangle) -> rl.Vector2 {
	x := (rect.x + rect.width) / 2
	return {x, 0}
}

GetCenterY :: proc(rect: rl.Rectangle) -> rl.Vector2 {
	y := (rect.y + rect.height) / 2
	return {0, y}
}

GetCenter :: proc(rect: rl.Rectangle) -> rl.Vector2 {
	x := (rect.x + rect.width) / 2
	y := (rect.y + rect.height) / 2
	return {x, y}
}