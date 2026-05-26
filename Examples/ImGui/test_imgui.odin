package test_imgui

import ex "../.."
import "core:fmt"
import "core:strings"
import rl "vendor:raylib"

main :: proc() {
	rl.InitWindow(600, 600, "Test Imgui")
	defer rl.CloseWindow()


	is_window_open := true

	name_buffer := make([]u8, 40)
	defer delete(name_buffer)
	name_edit: bool

	age_drop_down := ex.GuiPainterDropdownBoxOptions {
		active = 0,
	}

	person: struct {
		name:     string,
		ageGroup: i32,
		parent:   bool,
	}

	for !rl.WindowShouldClose() {
		WindowSize := cast(rl.Vector2)[2]i32{rl.GetScreenWidth(), rl.GetScreenHeight()}

		ex.GuiPainterSetCursorPos(0)
		ex.GuiPainterSetCursorSize(WindowSize)

		rl.BeginDrawing()
		rl.ClearBackground(rl.WHITE)

		if is_window_open {
			is_window_open = !ex.GuiPainterWindowBox({250, 250}, "Hello!")
			//Name Input
			ex.GuiPainterLabel("Enter your name:")
			ex.GuiPainterSameLine()
			if ex.GuiPainterTextBox(name_buffer, cast(i32)len(name_buffer), &name_edit) {
				person.name = strings.trim_null(string(name_buffer))
			}

			//Age Input
			ex.GuiPainterLabel("Enter your age:")
			ex.GuiPainterSameLine()
			ex.GuiPainterFillWidth()
			if ex.GuiPainterDropdownBox("Child;Teenager;Adult;Senior", &age_drop_down) do person.ageGroup = age_drop_down.active

			//Parent Input
			ex.GuiPainterLabel("Are you a parent?:")
			ex.GuiPainterCheckBox("Yes", &person.parent)

			//Output
			if ex.GuiPainterButton("Print info") do fmt.println(person)
		}

		if rl.IsKeyPressed(.R) do is_window_open = true

		rl.EndDrawing()

		free_all(context.temp_allocator)
	}
}
