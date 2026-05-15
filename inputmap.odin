package extra

import "core:math/linalg"
//Input map system for rebinding, compositie actions and named action using an enum

import "base:intrinsics"
import "core:encoding/json"
import "core:log"
import "core:os"
import rl "vendor:raylib"

InputBoolType :: enum {
	Pressed,
	Released,
	Down,
	Up,
}

InputDirection1D :: enum u8 {
	Right,
	Left,
}

InputDirection2D :: enum u8 {
	Right,
	Left,
	Down,
	Up,
}

InputAction :: union #no_nil {
	InputBoolAction,
	InputAxis1DAction,
	InputAxis2DAction,
}

//Represents a bool action with a key and gamepad button
InputBoolAction :: struct {
	key:           rl.KeyboardKey,
	gamePadButton: rl.GamepadButton,
	value:         bool,
	type:          InputBoolType,
}

//Represents a float32 action with 2 keys and 1 gamepad axis
InputAxis1DAction :: struct {
	keys:        [InputDirection1D]rl.KeyboardKey,
	gamePadAxis: rl.GamepadAxis,
	value:       f32,
}

//Represents a vector2 action with 4 keys and 2 gamepad axis
InputAxis2DAction :: struct {
	keys:                                       [InputDirection2D]rl.KeyboardKey,
	horizontalGamePadAxis, verticalGamePadAxis: rl.GamepadAxis,
	value:                                      rl.Vector2,
}

//Saves input map to json, 'fileName can be different to have different input maps'
SaveInputMap :: proc(fileName: string, inputMap: ^[$T]InputAction) {
	file, f_err := os.create(fileName)
	assert(f_err == nil)
	defer os.close(file)
	writer := os.to_writer(file)
	opt := json.Marshal_Options {
		use_enum_names = true,
	}
	json.marshal_to_writer(writer, inputMap^, &opt)
}

//Loads an input map, returns a bool declaring whether it was a success or not
//Also logs if failure
//Bool can be used to load map if created, and create if not created
LoadInputMap :: proc(
	fileName: string,
	$T: typeid,
) -> (
	^T,
	bool,
) where intrinsics.type_is_enum(T) #optional_ok {
	file, open_error := os.open(fileName)
	if open_error != nil {
		log.errorf("Failed to load input map at {0} due to {1}", fileName, open_error)
		return nil, false
	}
	inputMap, allocator_error := new([T]InputAction)
	if allocator_error != nil {
		log.errorf(
			"Failed to allocated memory for input map {0} due to {1}",
			fileName,
			allocator_error,
		)
		return nil, false
	}
	data, read_error := os.read_entire_file(fileName, context.temp_allocator)
	if read_error != nil {
		log.errorf("Failed to load input map at {0} due to {1}", fileName, read_error)
		return nil, false
	}
	err := json.unmarshal(data, inputMap, allocator = context.temp_allocator)
	if err != nil {
		log.errorf("Failed to unmarshal {0} due to {1}", fileName, err)
		return nil, false
	}
	return inputMap, true
}

//Updates the input values of the actions, should be called once per frame
InputUpdate :: proc(inputMap: ^[$T]InputAction) where intrinsics.type_is_enum(T) {
	for &action in inputMap {
		switch &e in action {
		case InputBoolAction:
			switch e.type {
			case .Pressed:
				e.value = rl.IsKeyPressed(e.key) || rl.IsGamepadButtonPressed(1, e.gamePadButton)
			case .Released:
				e.value = rl.IsKeyReleased(e.key) || rl.IsGamepadButtonReleased(1, e.gamePadButton)
			case .Down:
				e.value = rl.IsKeyDown(e.key) || rl.IsGamepadButtonDown(1, e.gamePadButton)
			case .Up:
				e.value = rl.IsKeyUp(e.key) || rl.IsGamepadButtonUp(1, e.gamePadButton)
			}

		case InputAxis1DAction:
			e.value = rl.GetGamepadAxisMovement(1, e.gamePadAxis)
			if rl.IsKeyDown(e.keys[.Right]) do e.value += 1.0
			if rl.IsKeyDown(e.keys[.Left]) do e.value -= 1.0
			e.value = clamp(e.value, -1, 1)

		case InputAxis2DAction:
			e.value.x = rl.GetGamepadAxisMovement(1, e.horizontalGamePadAxis)
			e.value.y = rl.GetGamepadAxisMovement(1, e.verticalGamePadAxis)
			if rl.IsKeyDown(e.keys[.Right]) do e.value.x += 1.0
			if rl.IsKeyDown(e.keys[.Down]) do e.value.y += 1.0
			if rl.IsKeyDown(e.keys[.Left]) do e.value.x -= 1.0
			if rl.IsKeyDown(e.keys[.Up]) do e.value.y -= 1.0
			e.value = linalg.clamp(e.value, -1, 1)
		}
	}
}

//Gets bool value from input action, returns false if action is not a bool value
InputGetBool :: proc(
	inputMap: ^[$T]InputAction,
	inputName: T,
) -> bool where intrinsics.type_is_enum(T) {
	if action, ok := inputMap[inputName].(InputBoolAction); ok do return action.value
	return false
}

//Gets float value from input action, returns 0.0 if action is not a float value
InputGetAxis1D :: proc(
	inputMap: ^[$T]InputAction,
	inputName: T,
) -> f32 where intrinsics.type_is_enum(T) {
	if action, ok := inputMap[inputName].(InputAxis1DAction); ok do return action.value
	return 0.0
}

//Gets float value from input action, returns 0.0 if action is not a float value
InputGetAxis2D :: proc(
	inputMap: ^[$T]InputAction,
	inputName: T,
) -> rl.Vector2 where intrinsics.type_is_enum(T) {
	if action, ok := inputMap[inputName].(InputAxis2DAction); ok do return action.value
	return 0.0
}

//Creates a button action, defaults to unknown for gamepad
CreateButtonAction :: proc(
	key: rl.KeyboardKey,
	gamePadButton := rl.GamepadButton.UNKNOWN,
	type := InputBoolType.Pressed,
) -> InputBoolAction {
	action := InputBoolAction {
		key           = key,
		gamePadButton = gamePadButton,
		value         = false,
		type          = type,
	}
	return action
}

//Creates an 1D axis action, defaults to invalid for gamepad
CreateAxis1DAction :: proc(
	keys: [InputDirection1D]rl.KeyboardKey,
	gamePadAxis := rl.GamepadAxis(-1),
) -> InputAxis1DAction {
	action := InputAxis1DAction {
		keys        = keys,
		gamePadAxis = gamePadAxis,
		value       = 0,
	}
	return action
}

//Creates an 2D axis action, defaults to invalid for gamepad
CreateAxis2DAction :: proc(
	keys: [InputDirection2D]rl.KeyboardKey,
	xAxis := rl.GamepadAxis(-1),
	yAxis := rl.GamepadAxis(-1),
) -> InputAxis2DAction {
	action := InputAxis2DAction {
		keys                  = keys,
		horizontalGamePadAxis = xAxis,
		verticalGamePadAxis   = yAxis,
		value                 = 0,
	}
	return action
}
