package test_input_map

import ex "../.."
import "core:fmt"
import rl "vendor:raylib"

InputActions :: enum {
	Move,
	Tint,
	Print,
}

GOOD_COLOR :: rl.GREEN
EVIL_COLOR :: rl.RED
PLAYER_SPEED :: 260

main :: proc() {
	rl.InitWindow(600, 600, "Test rectangle")
	defer rl.CloseWindow()

	inputMap := [InputActions]ex.InputAction {
		.Move = ex.CreateAxis2DAction({.Right = .D, .Left = .A, .Down = .S, .Up = .W}),
        .Tint = ex.CreateAxis1DAction({.Right = .I, .Left = . J}),
        .Print = ex.CreateButtonAction(.SPACE, type = .Pressed)
    }

    playerPosition : rl.Vector2
    playerTint: rl.Color
    playerTintOffset: f32


	for !rl.WindowShouldClose() {

        dt := rl.GetFrameTime()

		rl.BeginDrawing()
		rl.ClearBackground(rl.WHITE)
        ex.InputUpdate(&inputMap)

        playerPosition += ex.InputGetAxis2D(&inputMap, InputActions.Move) * dt * PLAYER_SPEED
        playerTintOffset += ex.InputGetAxis1D(&inputMap, InputActions.Tint) * dt
        playerTintOffset = clamp(playerTintOffset, 0, 1)

        playerTint = rl.ColorLerp(EVIL_COLOR, GOOD_COLOR, playerTintOffset)

        if ex.InputGetBool(&inputMap, InputActions.Print) do fmt.println("Printing text!")

        rl.DrawRectangleV(playerPosition, 80, playerTint)

		rl.EndDrawing()

		free_all(context.temp_allocator)
	}
}
