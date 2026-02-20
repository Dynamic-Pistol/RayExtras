package extra

import "core:log"
//This contains procs to help with setting and getting rect parts

import rl "vendor:raylib"

RectPartX :: enum u8 {
	None,
	Left,
	Right,
	Center,
}

RectPartY :: enum u8 {
	None,
	Top,
	Bottom,
	Center,
}

RectGetPart :: proc(rect: rl.Rectangle, xPart: RectPartX, yPart: RectPartY) -> rl.Vector2 {

	position := rl.Vector2{}

	switch xPart {
	case .None:
	case .Left:
		position.x = rect.x
	case .Right:
		position.x = rect.x + rect.width
	case .Center:
		position.x = (rect.x + rect.width) / 2
	}

	switch yPart {
	case .None:
	case .Top:
		position.y = rect.y
	case .Bottom:
		position.y = rect.y + rect.height
	case .Center:
		position.y = (rect.y + rect.height) / 2

	}

	return position
}

RectSetPart :: proc(
	rect: ^rl.Rectangle,
	xPart: RectPartX,
	yPart: RectPartY,
	position: rl.Vector2,
) {

	switch xPart {
	case .None:
	case .Left:
		rect.x = position.x
	case .Right:
		rect.x = position.x - rect.width
	case .Center:
		rect.x = position.x - (rect.width / 2)
	}

	switch yPart {
	case .None:
	case .Top:
		rect.y = position.y
	case .Bottom:
		rect.y = position.y - rect.height
	case .Center:
		rect.y = position.y - (rect.height / 2)

	}

}
