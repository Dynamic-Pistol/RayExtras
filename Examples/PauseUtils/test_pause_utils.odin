package test_pause_utils

import "core:math"
import ex "../.."
import rl "vendor:raylib"

FONT_SIZE :: 20

main :: proc() {
	rl.InitWindow(600, 600, "Test rectangle")
	defer rl.CloseWindow()

    totalTime: f32
	for !rl.WindowShouldClose() {

		rl.BeginDrawing()
		rl.ClearBackground(rl.WHITE)

        if rl.IsKeyPressed(.P) do ex.PauseToggle()

        totalTime += ex.PauseGetDeltaTime()

        position := 300 + rl.Vector2{math.sin(totalTime), math.cos(totalTime)} * 200

        rl.DrawLineV(300, position, rl.BLACK)

        if ex.PauseCheck() do rl.DrawText("Game paused", 0, 0, 40, rl.BLACK)

		rl.EndDrawing()

		free_all(context.temp_allocator)
	}
}
