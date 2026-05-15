//Package for pausing and unpausing game
package extra

import rl "vendor:raylib"

@(private)
PauseState :: struct {
	timeScale: f32,
	isPaused:  bool,
}

@(private)
pause_state := PauseState {
	isPaused  = false,
	timeScale = 1.0,
}

//Pauses the game
PauseStart :: proc(){
    pause_state.isPaused = true
}

//Unpauses the game
PauseStop :: proc(){
    pause_state.isPaused = false
}

//Toggles pausing the game
PauseToggle :: proc(){
    pause_state.isPaused = !pause_state.isPaused
}

//Sets game timescale
PauseSetTimeScale :: proc(timeScale: f32){
    pause_state.timeScale = timeScale
}

//Checks if the game is paused
PauseCheck :: proc() -> bool{
    return pause_state.isPaused
}

//Get the delta time with pausing and slowing down
PauseGetDeltaTime :: proc() -> f32 {
	if pause_state.isPaused do return 0.0
	return rl.GetFrameTime() * pause_state.timeScale
}
