package test_rect_utils

import ex "../.."
import "core:math"
import rl "vendor:raylib"

RECT_SIZE :: 600
FONT_SIZE :: 40

main :: proc() {
	rl.InitWindow(600, 600, "Test rectangle")
	defer rl.CloseWindow()

	gradient: ex.Gradient
	defer delete(gradient)

	ex.GradientAddPoint(&gradient, rl.RED, 0)
	ex.GradientAddPoint(&gradient, rl.GREEN, 0.25)
	ex.GradientAddPoint(&gradient, rl.BLUE, 0.5)
	ex.GradientAddPoint(&gradient, rl.RAYWHITE, 0.75)
	ex.GradientAddPoint(&gradient, rl.BEIGE, 1)

	mode: bool

	for !rl.WindowShouldClose() {

		totalTime := cast(f32)rl.GetTime()

		samplePoint := abs(math.sin(totalTime))

		if rl.IsKeyPressed(.SPACE) do mode = !mode

		rl.BeginDrawing()
		rl.ClearBackground(rl.WHITE)

		if mode {
			rl.DrawRectangleV(0, RECT_SIZE, ex.GradientSampleLinear(gradient, samplePoint))
			rl.DrawText("Linear sampling", 0, 0, FONT_SIZE, rl.BLACK)

		} else {
			rl.DrawRectangleV(0, RECT_SIZE, ex.GradientSampleConstant(gradient, samplePoint))
			rl.DrawText("Constant sampling", 0, 0, FONT_SIZE, rl.BLACK)
		}

		rl.EndDrawing()

		free_all(context.temp_allocator)
	}
}
