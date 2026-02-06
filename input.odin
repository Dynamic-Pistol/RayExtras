package extra

import "base:intrinsics"
import "core:encoding/json"
import "core:log"
import os "core:os/os2"
import rl "vendor:raylib"

InputAction :: union #no_nil {
	InputAxisAction,
	InputBoolAction,
}

InputAxisAction :: struct {
	positiveKey: rl.KeyboardKey,
	negativeKey: rl.KeyboardKey,
	gamePadAxis: rl.GamepadAxis,
	value:       i8,
}

InputBoolAction :: struct {
	key:           rl.KeyboardKey,
	gamePadButton: rl.GamepadButton,
	value:         bool,
}


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

LoadInputMap :: proc(
	fileName: string,
	$T: typeid,
) -> (
	^T,
	bool,
) where intrinsics.type_is_enum(T) #optional_ok {
	file, f_err := os.open(fileName)
	if f_err != nil {
		log.errorf("Failed to load input map at {0}", fileName)
		return nil, false
	}
	inputMap := new([T]InputAction)
	data, err := os.read_entire_file(fileName, context.temp_allocator)
	if err != nil {
		return nil, false
	}
	json.unmarshal(data, inputMap, allocator = context.temp_allocator)
	return inputMap, true
}

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

InputGetAxis :: proc(
	inputMap: ^[$T]InputAction,
	inputName: T,
) -> f32 where intrinsics.type_is_enum(T) {
	if action, ok := inputMap[inputName].(InputAxisAction); ok do return f32(action.value)
	return 0.0
}

InputGetBool :: proc(
	inputMap: ^[$T]InputAction,
	inputName: T,
) -> bool where intrinsics.type_is_enum(T) {
	if action, ok := inputMap[inputName].(InputBoolAction); ok do return action.value
	return false
}

CreateAxisAction :: proc(
	positiveKey: rl.KeyboardKey,
	negativeKey: rl.KeyboardKey,
	gamePadAxis := rl.GamepadAxis(-1),
) -> InputAxisAction {
	action := InputAxisAction {
		positiveKey = positiveKey,
		negativeKey = negativeKey,
		value       = 0,
	}
	return action
}

CreateButtonAction :: proc(
	key: rl.KeyboardKey,
	gamePadButton := rl.GamepadButton.UNKNOWN,
) -> InputBoolAction {
	action := InputBoolAction {
		key   = key,
		value = false,
	}
	return action
}

InputRegisterAxisAction :: proc(
	inputMap: ^[$T]InputAction,
	inputName: T,
	positiveKey: rl.KeyboardKey,
	negativeKey: rl.KeyboardKey,
) where intrinsics.type_is_enum(T) {
	action := &inputMap.actions[inputName].(InputAxisAction)
	action.positiveKey = positiveKey
	action.negativeKey = negativeKey
}

InputRegisterBoolAction :: proc(
	inputMap: ^[$T]InputAction,
	inputName: T,
	key: rl.KeyboardKey,
) where intrinsics.type_is_enum(T) {
	action := &inputMap.actions[inputName].(InputBoolAction)
	action.key = key
}
