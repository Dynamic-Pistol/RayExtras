//Timer system
package extra

Timer :: struct {
	waitTime, timeLeft: f32,
	active, paused:     bool,
}

//Creates a timer that waits for `waitTime`
TimerCreate :: proc(waitTime: f32) -> Timer {
	return {waitTime = waitTime, timeLeft = waitTime, active = false, paused = false}
}

//Starts or restarts a timer
TimerStart :: proc(timer: ^Timer) {
	timer.active = true
	timer.timeLeft = timer.waitTime
}

//Stops a timer
TimerStop :: proc(timer: ^Timer) {
	timer.active = false
}

//Pauses a timer
TimerPause :: proc(timer: ^Timer) {
	timer.paused = true
}

//Unpauses a timer
TimerUnpause :: proc(timer: ^Timer) {
	timer.paused = false
}

//Updates a timer
TimerUpdate :: proc(timer: ^Timer, deltaTime: f32) {
	if !timer.active || timer.paused {
		return
	}
	timer.timeLeft -= deltaTime
	if timer.timeLeft < 0.0 {
		timer.timeLeft = 0.0
		timer.active = false
	}
}

//Updates multiple timers
TimersUpdate :: proc {
	_update_timers_fixed_array,
	_update_timers_dynamic_array,
}

@(private)
_update_timers_fixed_array :: proc(timers: ^[$N]Timer, deltaTime: f32) {
	for &timer in timers do TimerUpdate(timer, deltaTime)
}

@(private)
_update_timers_dynamic_array :: proc(timers: [dynamic]Timer, deltaTime: f32) {
	for &timer in timers do TimerUpdate(&timer, deltaTime)
}

//Checks if a timer is active
TimerIsActive :: proc(timer: Timer) -> bool {
	return timer.active
}

//Checks if a timer is paused
TimerIsPaused :: proc(timer: Timer) -> bool {
	return timer.paused
}

//Checks if timer is done
TimerIsDone :: proc(timer: ^Timer) -> bool {
	return timer.timeLeft == 0.0
}
