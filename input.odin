package extra

//Input map system for rebinding, compositie actions and named action using an enum

import "base:intrinsics"
import "core:encoding/json"
import "core:log"
import os "core:os/os2"
import rl "vendor:raylib"

InputAction :: union #no_nil {
	InputAxisAction,
	InputBoolAction,
}

//Represents a float32 action with 2 keys and 1 gamepad axis
InputAxisAction :: struct {
	positiveKey: rl.KeyboardKey,
	negativeKey: rl.KeyboardKey,
	gamePadAxis: rl.GamepadAxis,
	value:       i8,
}

//Represents a bool action with a key and gamepad button
InputBoolAction :: struct {
	key:           rl.KeyboardKey,
	gamePadButton: rl.GamepadButton,
	value:         bool,
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
	if allocator_error != nil{
		log.errorf("Failed to allocated memory for input map {0} due to {1}", fileName, allocator_error)
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
		case InputAxisAction:
			e.value = i8(rl.GetGamepadAxisMovement(1, e.gamePadAxis))
			if rl.IsKeyDown(e.positiveKey) do e.value += 1.0
			if rl.IsKeyDown(e.negativeKey) do e.value -= 1.0
			e.value = clamp(e.value, -1, 1)

		case InputBoolAction:
			e.value = rl.IsKeyDown(e.key) || rl.IsGamepadButtonDown(1, e.gamePadButton)
		}
	}
}

//Gets float value from input action, returns 0.0 if action is not a float value
InputGetAxis :: proc(
	inputMap: ^[$T]InputAction,
	inputName: T,
) -> f32 where intrinsics.type_is_enum(T) {
	if action, ok := inputMap[inputName].(InputAxisAction); ok do return f32(action.value)
	return 0.0
}

//Gets bool value from input action, returns false if action is not a bool value
InputGetBool :: proc(
	inputMap: ^[$T]InputAction,
	inputName: T,
) -> bool where intrinsics.type_is_enum(T) {
	if action, ok := inputMap[inputName].(InputBoolAction); ok do return action.value
	return false
}

//Creates an axis action, defaults to invalid for gamepad 
CreateAxisAction :: proc(
	positiveKey: rl.KeyboardKey,
	negativeKey: rl.KeyboardKey,
	gamePadAxis := rl.GamepadAxis(-1),
) -> InputAxisAction {
	action := InputAxisAction {
		positiveKey = positiveKey,
		negativeKey = negativeKey,
		gamePadAxis = gamePadAxis,
		value       = 0,
	}
	return action
}

//Creates a button action, defaults to unknown for gamepad
CreateButtonAction :: proc(
	key: rl.KeyboardKey,
	gamePadButton := rl.GamepadButton.UNKNOWN,
) -> InputBoolAction {
	action := InputBoolAction {
		key   = key,
		gamePadButton = gamePadButton,
		value = false,
	}
	return action
}