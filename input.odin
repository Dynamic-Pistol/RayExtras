package extra

import "core:log"
import os "core:os/os2"
import "base:intrinsics"
import "core:encoding/json"
import rl "vendor:raylib"

InputAction :: union #no_nil {
	InputAxisAction,
	InputBoolAction,
}

InputAxisAction :: struct {
	positiveKey: rl.KeyboardKey,
	negativeKey: rl.KeyboardKey,
	value:       i8,
}

InputBoolAction :: struct {
	key:   rl.KeyboardKey,
	value: bool,
}

//Input map storing action, create using `CreateInputMap`, Destroy using `DestroyInputMap`
// InputMap :: distinct map[InputName]InputAction
InputMap :: struct($T: typeid) where intrinsics.type_is_enum(T) {
	actions: [T]InputAction,
}

CreateInputMap :: proc(actions: [$T]InputAction) -> ^InputMap(T) {
	inputMap := new(InputMap(T))
	inputMap.actions = actions
	return inputMap
}

DestroyInputMap :: free

SaveInputMap :: proc(fileName: string, inputMap: ^InputMap($T)) {
	file, f_err := os.create(fileName)
	assert(f_err == nil)
	defer os.close(file)
	writer := os.to_writer(file)
	opt := json.Marshal_Options {
		use_enum_names = true,
	}
	json.marshal_to_writer(writer, inputMap^, &opt)
}

LoadInputMap :: proc(fileName: string, $T: typeid) -> (^InputMap(T), bool) #optional_ok {
	file, f_err := os.open(fileName)
	if f_err != nil{
		log.errorf("Failed to load input map at {0}", fileName)
		return nil, false
	}
	inputMap := new(InputMap(T))
	data, err := os.read_entire_file(fileName, context.temp_allocator)
	if err != nil{
		return nil, false
	}
	json.unmarshal(data, inputMap, allocator = context.temp_allocator)
	return inputMap, true
}

InputUpdate :: proc(inputMap: ^InputMap($T)) {
	for &action in inputMap.actions {
		switch &e in action {
		case InputAxisAction:
			e.value = 0
			if rl.IsKeyDown(e.positiveKey) do e.value += 1.0
			if rl.IsKeyDown(e.negativeKey) do e.value -= 1.0
		case InputBoolAction:
			e.value = rl.IsKeyDown(e.key)
		}
	}
}

InputGetAxis :: proc(inputMap: ^InputMap($T), inputName: T) -> f32 {
	if action, ok := inputMap.actions[inputName].(InputAxisAction); ok do return f32(action.value)
	return 0.0
}

InputGetBool :: proc(inputMap: ^InputMap($T), inputName: T) -> bool {
	if action, ok := inputMap.actions[inputName].(InputBoolAction); ok do return action.value
	return false
}

CreateAxisAction :: proc(
	positiveKey: rl.KeyboardKey,
	negativeKey: rl.KeyboardKey,
) -> InputAxisAction {
	action := InputAxisAction {
		positiveKey = positiveKey,
		negativeKey = negativeKey,
		value       = 0,
	}
	return action
}

CreateButtonAction :: proc(key: rl.KeyboardKey) -> InputBoolAction {
	action := InputBoolAction {
		key   = key,
		value = false,
	}
	return action
}

InputRegisterAxisAction :: proc(
	inputMap: ^InputMap($T),
	inputName: T,
	positiveKey: rl.KeyboardKey,
	negativeKey: rl.KeyboardKey,
) {
	action := &inputMap.actions[inputName].(InputAxisAction)
	action.positiveKey = positiveKey
	action.negativeKey = negativeKey
}

InputRegisterBoolAction :: proc(inputMap: ^InputMap($T), inputName: T, key: rl.KeyboardKey) {
	action := &inputMap.actions[inputName].(InputBoolAction)
	action.key = key
}
