package test_input_utils

import "core:fmt"
import ex "../.."
import rl "vendor:raylib"

main :: proc() {
	rl.InitWindow(600, 600, "Test rectangle")
	defer rl.CloseWindow()

	mode: bool

	for !rl.WindowShouldClose() {

		rl.BeginDrawing()
		rl.ClearBackground(mode ? rl.WHITE : rl.BLACK)

        if ex.IsMouseButtonDoubleClicked(.LEFT) do mode = !mode

        if ex.IsKeyboardKeyDoublePressed(.SPACE) do fmt.println("Double space press!!!")

		rl.EndDrawing()

		free_all(context.temp_allocator)
	}
}
