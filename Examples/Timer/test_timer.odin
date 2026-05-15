package test_rect_utils

import ex "../.."
import rl "vendor:raylib"

FONT_SIZE :: 40

main :: proc() {
	rl.InitWindow(600, 600, "Test rectangle")
	defer rl.CloseWindow()

	timer := ex.TimerCreate(5.0)

	for !rl.WindowShouldClose() {

		ex.TimerUpdate(&timer, rl.GetFrameTime())

		rl.BeginDrawing()
		rl.ClearBackground(rl.WHITE)

		if rl.IsKeyPressed(.S) do if ex.TimerIsActive(timer) do ex.TimerStop(&timer)
		else do ex.TimerStart(&timer)

		if rl.IsKeyPressed(.P) do if ex.TimerIsPaused(timer) do ex.TimerUnpause(&timer)
		else do ex.TimerPause(&timer)

        if ex.TimerIsPaused(timer) do rl.DrawText("Timer is paused!", 0, FONT_SIZE, FONT_SIZE, rl.BLACK)
		if ex.TimerIsDone(&timer) do rl.DrawText("Timer is done!", 0, 0, FONT_SIZE, rl.BLACK)
		else if !ex.TimerIsActive(timer) do rl.DrawText("Timer is not active!", 0, 0, FONT_SIZE, rl.BLACK)
		else if ex.TimerIsActive(timer) do rl.DrawText("Timer is running!", 0, 0, FONT_SIZE, rl.BLACK)

		rl.EndDrawing()

		free_all(context.temp_allocator)
	}
}
