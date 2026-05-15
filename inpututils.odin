package extra

import rl "vendor:raylib"


IsMouseButtonDoubleClicked :: proc(button: rl.MouseButton) -> bool {
	@(static) lastClickTimes: [rl.MouseButton]f64
    if !rl.IsMouseButtonPressed(button) do return false
	doubleClicked := false

	currentTime := rl.GetTime()
	if (currentTime - lastClickTimes[button] < 0.3) { 	// 0.3 seconds threshold
		doubleClicked = true
	}
	lastClickTimes[button] = currentTime
	return doubleClicked
}

IsKeyboardKeyDoublePressed :: proc(key: rl.KeyboardKey) -> bool{
	@(static) lastClickTimes: #sparse[rl.KeyboardKey]f64
    if !rl.IsKeyPressed(key) do return false
	doubleClicked := false

	currentTime := rl.GetTime()
	if (currentTime - lastClickTimes[key] < 0.3) { 	// 0.3 seconds threshold
		doubleClicked = true
	}
	lastClickTimes[key] = currentTime
	return doubleClicked
}
