package extra

import rl "vendor:raylib"

//Gets the left center of the rectangle
RectGetLeft :: proc(rect: rl.Rectangle) -> rl.Vector2 {
	x := rect.x
	y := rect.y + rect.height / 2
	return {x, y}
}

//Sets the left center of the rectangle
RectSetLeft :: proc(rect: ^rl.Rectangle, position: rl.Vector2) {
	rect.x = position.x
	rect.y = position.y - rect.height / 2
}

//Gets the right center of the rectangle
RectGetRight :: proc(rect: rl.Rectangle) -> rl.Vector2 {
	x := rect.x + rect.width
	y := rect.y + rect.height / 2
	return {x, y}
}

//Sets the right center of the rectangle
RectSetRight :: proc(rect: ^rl.Rectangle, position: rl.Vector2) {
	rect.x = position.x - rect.width
	rect.y = position.y - rect.height / 2
}

//Gets the top center of the rectangle
RectGetTop :: proc(rect: rl.Rectangle) -> rl.Vector2 {
	x := rect.x + rect.width / 2
	y := rect.y
	return {x, y}
}

//Sets the top center of the rectangle
RectSetTop :: proc(rect: ^rl.Rectangle, position: rl.Vector2) {
	rect.x = position.x - rect.width / 2
	rect.y = position.y
}

//Gets the bottom center of the rectangle
RectGetBottom :: proc(rect: rl.Rectangle) -> rl.Vector2 {
	x := rect.x + rect.width / 2
	y := rect.y + rect.height
	return {x, y}
}

//Sets the bottom center of the rectangle
RectSetBottom :: proc(rect: ^rl.Rectangle, position: rl.Vector2) {
	rect.x = position.x - rect.width / 2
	rect.y = position.y - rect.height
}
