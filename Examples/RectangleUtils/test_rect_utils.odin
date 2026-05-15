package test_rect_utils

import ex "../.."
import rl "vendor:raylib"

TOOLTIP_TEXT :: "This is a tooltip!"
FONT_SIZE :: 20

main :: proc() {
	rl.InitWindow(600, 600, "Test rectangle")
	defer rl.CloseWindow()

	textWidth := rl.MeasureText(TOOLTIP_TEXT, FONT_SIZE)
	rect: rl.Rectangle = {0, 0, f32(textWidth) + 2, 30}

	for !rl.WindowShouldClose() {

		rl.BeginDrawing()
		rl.ClearBackground(rl.WHITE)

		mousePos := rl.GetMousePosition()
		mousePosInt := cast([2]i32) mousePos

		ex.RectSetPart(&rect, .Left, .Top, mousePos)

		rl.DrawRectangleRec(rect, rl.BLACK)
		rl.DrawText(TOOLTIP_TEXT, mousePosInt.x, mousePosInt.y + 5, FONT_SIZE, rl.WHITE)

		rl.EndDrawing()

		free_all(context.temp_allocator)
	}
}
