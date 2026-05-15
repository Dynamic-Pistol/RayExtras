package test_rect_utils

import "core:log"
import ex "../.."
import rl "vendor:raylib"


main :: proc() {
	rl.InitWindow(600, 600, "Test rectangle")
	defer rl.CloseWindow()

    context.logger = ex.CreateRaylibLogger()
    rl.SetTraceLogLevel(.ALL)

	for !rl.WindowShouldClose() {

		rl.BeginDrawing()
		rl.ClearBackground(rl.WHITE)

        if rl.IsKeyPressed(.D) do log.debug("Beep boop")
        if rl.IsKeyPressed(.I) do log.info("Did you know that a shrimp's heart is located in it's head?")
        if rl.IsKeyPressed(.W) do log.warn("Something's wrong...")
        if rl.IsKeyPressed(.E) do log.error("Oh no!")
        if rl.IsKeyPressed(.F) do log.fatal("Did you know raylib crashes on fatal?")

		rl.EndDrawing()

		free_all(context.temp_allocator)
	}
}
