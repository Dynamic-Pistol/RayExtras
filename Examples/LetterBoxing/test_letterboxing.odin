package test_input_utils

import "core:fmt"
import ex "../.."
import rl "vendor:raylib"

main :: proc() {
    rl.SetConfigFlags({.WINDOW_RESIZABLE})
	rl.InitWindow(600, 600, "Test Letterbox")
	defer rl.CloseWindow()

    testTexture := rl.LoadTexture("background.png")
    defer rl.UnloadTexture(testTexture)

    letterBoxTexture := rl.LoadRenderTexture(1280, 720)
    defer rl.UnloadRenderTexture(letterBoxTexture)

	for !rl.WindowShouldClose() {

		rl.BeginDrawing()
		rl.ClearBackground(rl.WHITE)
        rl.BeginTextureMode(letterBoxTexture)
        rl.DrawTextureV(testTexture, 0, rl.WHITE)
        rl.EndTextureMode()
        ex.DrawGameLetterBox(letterBoxTexture)
		rl.EndDrawing()

		free_all(context.temp_allocator)
	}
}
