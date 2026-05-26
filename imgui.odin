//Port of https://github.com/mdavisprog/rayguipainter/tree/main to odinlang

package extra

import "core:fmt"
import "core:strings"
import rl "vendor:raylib"

RAYGUI_WINDOWBOX_STATUSBAR_HEIGHT :: 24

GuiPainterDropdownBoxOptions :: struct {
	active: i32,
	edit:   bool,
}

GuiPainterValueBoxOptions :: struct {
	value, minValue, maxValue: i32,
	edit:                      bool,
}

GuiPainterSliderOptions :: struct {
	value, minValue, maxValue: f32,
}

GuiPainterListViewOptions :: struct {
	scrollIndex, active, visibleListItems: i32,
}

@(private)
guiPainterCursorPos: rl.Vector2 = {0, 0}
@(private)
guiPainterCursorAnchorPos: rl.Vector2 = {0, 0}
@(private)
guiPainterCursorPrevPos: rl.Vector2 = {0, 0}
@(private)
guiPainterCursorSize: rl.Vector2 = {0, 0}
@(private)
guiPainterControlSpacing: rl.Vector2 = {4, 4}
@(private)
guiPainterButtonPadding: rl.Vector2 = {6, 4}
@(private)
guiPainterTextBoxWidth: f32 = 100
@(private)
guiPainterSliderWidth: f32 = 100
@(private)
guiPainterFillWidth: bool = false

GuiPainterTextSize :: proc(text: string) -> rl.Vector2 {
	return rl.MeasureTextEx(
		rl.GuiGetFont(),
		strings.clone_to_cstring(text, context.temp_allocator),
		f32(rl.GuiGetStyle(.DEFAULT, cast(i32)rl.GuiDefaultProperty.TEXT_SIZE)),
		f32(rl.GuiGetStyle(.DEFAULT, cast(i32)rl.GuiDefaultProperty.TEXT_SPACING)),
	)
}

GuiPainterLargestTextSize :: proc(text: string) -> rl.Vector2 {
	result := rl.Vector2{}

	buffer: strings.Builder = ---
	strings.builder_init(&buffer, 1024)
	index := 0

	for char in text {
		if char == ';' {
			buffer.buf[index] = 0
			size := GuiPainterTextSize(strings.to_string(buffer))
			result.x = size.x > result.x ? size.x : result.x
			result.y = size.y > result.y ? size.y : result.y
            strings.builder_reset(&buffer)
			index = 0

		} else {
			strings.write_rune(&buffer, char)
		}
	}


	if index > 0 {
		buffer.buf[index] = 0
		size := GuiPainterTextSize(strings.to_string(buffer))
		result.x = size.x > result.x ? size.x : result.x
		result.y = size.y > result.y ? size.y : result.y
	}

	return result
}

GuiPainterItemCount :: proc(text: string) -> int {
	result := 1

	for char in text {
		if char == ';' do result += 1
	}

	return result
}

GuiPainterAdvanceCursorLine :: proc(controlBounds: rl.Rectangle) {
	guiPainterCursorPrevPos.x = controlBounds.x + controlBounds.width
	guiPainterCursorPrevPos.y = guiPainterCursorPos.y
	guiPainterCursorPos.x = guiPainterCursorAnchorPos.x
	guiPainterCursorPos.y += controlBounds.height + guiPainterControlSpacing.y
	guiPainterFillWidth = false
}

GuiPainterSuggestedWidth :: proc(width, padding: f32) -> f32 {
	result := width
	if guiPainterFillWidth {
		result =
			guiPainterCursorSize.x -
			(guiPainterCursorPos.x - guiPainterCursorAnchorPos.x) -
			(guiPainterControlSpacing.x * 2) -
			padding
	}
	return result
}

GuiPainterSetCursorPos :: proc(pos: rl.Vector2) {
	guiPainterCursorPos = pos
	guiPainterCursorAnchorPos = pos
}

GuiPainterGetCursorPos :: proc() -> rl.Vector2 {
	return guiPainterCursorPos
}

GuiPainterSetControlSpacing :: proc(spacing: rl.Vector2) {
	guiPainterControlSpacing = spacing
}

GuiPainterGetControlSpacing :: proc() -> rl.Vector2 {
	return guiPainterControlSpacing
}

GuiPainterSetCursorSize :: proc(size: rl.Vector2) {
	guiPainterCursorSize = size
}

GuiPainterGetCursorSize :: proc() -> rl.Vector2 {
	return guiPainterCursorSize
}

GuiPainterSameLine :: proc() {
	guiPainterCursorPos = guiPainterCursorPrevPos
}

GuiPainterNextLine :: proc() {
	height :=
		GuiPainterTextSize(" ").y + guiPainterButtonPadding.y * 2 + guiPainterControlSpacing.y
	guiPainterCursorPos.y += height
}

GuiPainterFillWidth :: proc() {
	guiPainterFillWidth = true
}

GuiPainterWindowBox :: proc(size: rl.Vector2, title: string) -> bool {
	bounds := rl.Rectangle{guiPainterCursorPos.x, guiPainterCursorPos.y, size.x, size.y}
	guiPainterCursorPos.y += RAYGUI_WINDOWBOX_STATUSBAR_HEIGHT + guiPainterControlSpacing.y
	guiPainterCursorSize = size
	return rl.GuiWindowBox(bounds, strings.clone_to_cstring(title, context.temp_allocator)) == 1
}

GuiPainterPanel :: proc(size: rl.Vector2, title: string) {
	bounds := rl.Rectangle{guiPainterCursorPos.x, guiPainterCursorPos.y, size.x, size.y}
	guiPainterCursorPos.y += RAYGUI_WINDOWBOX_STATUSBAR_HEIGHT + guiPainterControlSpacing.y
	guiPainterCursorSize = size
	rl.GuiPanel(bounds, strings.clone_to_cstring(title, context.temp_allocator))
}

GuiPainterLine :: proc(text: string) {
	textSize := GuiPainterTextSize(text)
	bounds := rl.Rectangle {
		guiPainterCursorPos.x + guiPainterControlSpacing.x,
		guiPainterCursorPos.y,
		guiPainterCursorSize.x - guiPainterControlSpacing.x * 2,
		textSize.y == 0 ? f32(rl.GuiGetStyle(.DEFAULT, cast(i32)rl.GuiDefaultProperty.TEXT_SIZE)) : textSize.y,
	}
	guiPainterCursorPos.y += bounds.height + guiPainterControlSpacing.y
	rl.GuiLine(bounds, strings.clone_to_cstring(text, context.temp_allocator))
}

GuiPainterLabel :: proc(text: string) {
	textSize := GuiPainterTextSize(text)
	bounds := rl.Rectangle {
		guiPainterCursorPos.x + guiPainterControlSpacing.x,
		guiPainterCursorPos.y,
		textSize.x + 6,
		textSize.y,
	}
	rl.GuiLabel(bounds, strings.clone_to_cstring(text, context.temp_allocator))
	GuiPainterAdvanceCursorLine(bounds)
}

GuiPainterButton :: proc(text: string) -> bool {
	textSize := GuiPainterTextSize(text)
	bounds := rl.Rectangle {
		guiPainterCursorPos.x + guiPainterControlSpacing.x,
		guiPainterCursorPos.y,
		GuiPainterSuggestedWidth(textSize.x + guiPainterButtonPadding.x * 2, 0),
		textSize.y + guiPainterButtonPadding.y * 2,
	}
	GuiPainterAdvanceCursorLine(bounds)
	return rl.GuiButton(bounds, strings.clone_to_cstring(text, context.temp_allocator))
}

GuiPainterLabelButton :: proc(text: string) -> bool {
	textSize := GuiPainterTextSize(text)
	bounds := rl.Rectangle {
		guiPainterCursorPos.x + guiPainterControlSpacing.x,
		guiPainterCursorPos.y,
		GuiPainterSuggestedWidth(textSize.x + guiPainterButtonPadding.x * 2, 0),
		textSize.y + guiPainterButtonPadding.y * 2,
	}
	GuiPainterAdvanceCursorLine(bounds)
	return rl.GuiLabelButton(bounds, strings.clone_to_cstring(text, context.temp_allocator))
}

GuiPainterToggle :: proc(text: string, active: ^bool) -> bool {
	textSize := GuiPainterTextSize(text)
	bounds := rl.Rectangle {
		guiPainterCursorPos.x + guiPainterControlSpacing.x,
		guiPainterCursorPos.y,
		GuiPainterSuggestedWidth(textSize.x + guiPainterButtonPadding.x * 2, 0),
		textSize.y + guiPainterButtonPadding.y * 2,
	}
	GuiPainterAdvanceCursorLine(bounds)
	rl.GuiToggle(bounds, strings.clone_to_cstring(text, context.temp_allocator), active)
	return active^
}

GuiPainterToggleGroup :: proc(text: string, active: ^i32) -> i32 {
	maxSize := GuiPainterLargestTextSize(text)
	itemCount := GuiPainterItemCount(text)
	bounds := rl.Rectangle {
		guiPainterCursorPos.x + guiPainterControlSpacing.x,
		guiPainterCursorPos.y,
		guiPainterFillWidth ? (GuiPainterSuggestedWidth(0, guiPainterControlSpacing.x) / f32(itemCount)) : maxSize.x + guiPainterButtonPadding.x * 2,
		maxSize.y + guiPainterButtonPadding.y * 2,
	}
	GuiPainterAdvanceCursorLine(bounds)
	rl.GuiToggleGroup(bounds, strings.clone_to_cstring(text, context.temp_allocator), active)
	return active^
}

GuiPainterCheckBox :: proc(text: string, active: ^bool) -> bool {
	size := f32(rl.GuiGetStyle(.DEFAULT, cast(i32)rl.GuiDefaultProperty.TEXT_SIZE))
	textSize := GuiPainterTextSize(text)
	bounds := rl.Rectangle {
		guiPainterCursorPos.x + guiPainterControlSpacing.x,
		guiPainterCursorPos.y,
		size + guiPainterButtonPadding.x * 2,
		size + guiPainterButtonPadding.y * 2,
	}
	advanceBounds := rl.Rectangle {
		bounds.x,
		bounds.y,
		bounds.width +
		textSize.x +
		cast(f32)rl.GuiGetStyle(.CHECKBOX, cast(i32)rl.GuiCheckBoxProperty.CHECK_PADDING),
		bounds.height,
	}
	GuiPainterAdvanceCursorLine(advanceBounds)
	return rl.GuiCheckBox(bounds, strings.clone_to_cstring(text, context.temp_allocator), active)
}

GuiPainterComboBox :: proc(text: string, active: ^i32) -> i32 {
	maxSize := GuiPainterLargestTextSize(text)
	bounds := rl.Rectangle {
		guiPainterCursorPos.x + guiPainterControlSpacing.x,
		guiPainterCursorPos.y,
		GuiPainterSuggestedWidth(
			maxSize.x +
			guiPainterButtonPadding.x +
			cast(f32)rl.GuiGetStyle(
					.COMBOBOX,
					cast(i32)rl.GuiComboBoxProperty.COMBO_BUTTON_WIDTH,
				) +
			cast(f32)rl.GuiGetStyle(
					.COMBOBOX,
					cast(i32)rl.GuiComboBoxProperty.COMBO_BUTTON_SPACING,
				),
			0,
		),
		maxSize.y + guiPainterButtonPadding.y * 2,
	}
	GuiPainterAdvanceCursorLine(bounds)
	return rl.GuiComboBox(bounds, strings.clone_to_cstring(text, context.temp_allocator), active)
}

GuiPainterDropdownBox :: proc(text: string, options: ^GuiPainterDropdownBoxOptions) -> bool {
	maxSize := GuiPainterLargestTextSize(text)
	bounds := rl.Rectangle {
		guiPainterCursorPos.x + guiPainterControlSpacing.x,
		guiPainterCursorPos.y,
		GuiPainterSuggestedWidth(
			maxSize.x +
			guiPainterButtonPadding.x +
			cast(f32)rl.GuiGetStyle(
					.DROPDOWNBOX,
					cast(i32)rl.GuiDropdownBoxProperty.ARROW_PADDING,
				) +
			16,
			0,
		),
		maxSize.y + guiPainterButtonPadding.y * 2,
	}
	GuiPainterAdvanceCursorLine(bounds)
	if rl.GuiDropdownBox(
		bounds,
		strings.clone_to_cstring(text, context.temp_allocator),
		&options.active,
		options.edit,
	) {
		options.edit = !options.edit
		return true
	}
	return false
}

GuiPainterValueBox :: proc(text: string, options: ^GuiPainterValueBoxOptions) -> bool {
	textSize := GuiPainterTextSize(text)
	maxValueSize := GuiPainterTextSize(fmt.tprint("%9d", options.maxValue))
	leftAligned :=
		rl.GuiGetStyle(.VALUEBOX, cast(i32)rl.GuiControlProperty.TEXT_PADDING) ==
		cast(i32)rl.GuiTextAlignment.TEXT_ALIGN_LEFT
	bounds := rl.Rectangle {
		guiPainterCursorPos.x +
		guiPainterControlSpacing.x +
		(leftAligned ? textSize.x + cast(f32)rl.GuiGetStyle(.VALUEBOX, cast(i32)rl.GuiControlProperty.TEXT_PADDING) : 0),
		guiPainterCursorPos.y,
		GuiPainterSuggestedWidth(maxValueSize.x + guiPainterButtonPadding.x * 2, textSize.x),
		maxValueSize.y + guiPainterButtonPadding.y * 2,
	}
	advanceBounds := rl.Rectangle {
		bounds.x,
		bounds.y,
		bounds.width +
		(leftAligned == false ? textSize.x + cast(f32)rl.GuiGetStyle(.VALUEBOX, cast(i32)rl.GuiControlProperty.TEXT_PADDING) : 0),
		bounds.height,
	}
	GuiPainterAdvanceCursorLine(advanceBounds)
	if rl.GuiValueBox(
		   bounds,
		   strings.clone_to_cstring(text, context.temp_allocator),
		   &options.value,
		   options.minValue,
		   options.maxValue,
		   options.edit,
	   ) >
	   0 {
		options.edit = !options.edit
		return true
	}
	return false
}

GuiPainterTextBox :: proc(text: []u8, textSize: i32, editMode: ^bool) -> bool {
	boxSize := GuiPainterTextSize(" ")
	bounds := rl.Rectangle {
		guiPainterCursorPos.x + guiPainterControlSpacing.x,
		guiPainterCursorPos.y,
		GuiPainterSuggestedWidth(guiPainterTextBoxWidth, 0),
		boxSize.y + guiPainterButtonPadding.y * 2,
	}
	GuiPainterAdvanceCursorLine(bounds)
	if rl.GuiTextBox(
		bounds,
		cstring(&text[0]),
		textSize,
		editMode^,
	) {
		editMode^ = !editMode^
		return true
	}
	return false
}

GuiPainterSlider :: proc(textLeft, textRight: string, options: ^GuiPainterSliderOptions) -> f32 {
	textPadding := cast(f32)rl.GuiGetStyle(.SLIDER, cast(i32)rl.GuiSliderProperty.SLIDER_PADDING)
	textLeftSize := GuiPainterTextSize(textLeft)
	textRightSize := GuiPainterTextSize(textRight)
	bounds := rl.Rectangle {
		guiPainterCursorPos.x + guiPainterControlSpacing.x + textLeftSize.x + textPadding,
		guiPainterCursorPos.y,
		GuiPainterSuggestedWidth(
			guiPainterSliderWidth,
			textLeftSize.x + textRightSize.x + textPadding + guiPainterControlSpacing.x,
		),
		cast(f32)rl.GuiGetStyle(.DEFAULT, cast(i32)rl.GuiDefaultProperty.TEXT_SIZE) +
		guiPainterButtonPadding.y * 2,
	}
	advanceBounds := rl.Rectangle {
		bounds.x,
		bounds.y,
		bounds.width + textRightSize.x + textPadding,
		bounds.height,
	}
	GuiPainterAdvanceCursorLine(advanceBounds)
	rl.GuiSlider(
		bounds,
		strings.clone_to_cstring(textLeft, context.temp_allocator),
		strings.clone_to_cstring(textRight, context.temp_allocator),
		&options.value,
		options.minValue,
		options.maxValue,
	)
	return options.value
}

GuiPainterListView :: proc(text: string, options: ^GuiPainterListViewOptions) -> i32 {
	numVisible := options.visibleListItems > 0 ? options.visibleListItems : 5
	scrollBarWidth := cast(f32)rl.GuiGetStyle(
		.LISTVIEW,
		cast(i32)rl.GuiListViewProperty.SCROLLBAR_WIDTH,
	)
	maxSize := GuiPainterLargestTextSize(text)
	bounds := rl.Rectangle {
		guiPainterCursorPos.x + guiPainterControlSpacing.x,
		guiPainterCursorPos.y,
		GuiPainterSuggestedWidth(maxSize.x + guiPainterButtonPadding.x * 2 + scrollBarWidth, 0),
		(cast(f32)rl.GuiGetStyle(.LISTVIEW, cast(i32)rl.GuiListViewProperty.LIST_ITEMS_HEIGHT) +
			cast(f32)rl.GuiGetStyle(
					.LISTVIEW,
					cast(i32)rl.GuiListViewProperty.LIST_ITEMS_SPACING,
				)) *
		cast(f32)numVisible,
	}
	GuiPainterAdvanceCursorLine(bounds)
	rl.GuiListView(
		bounds,
		strings.clone_to_cstring(text, context.temp_allocator),
		&options.scrollIndex,
		&options.active,
	)
	return options.active
}

GuiPainterImage :: proc(texture: rl.Texture, tint: rl.Color) -> bool {
	position := rl.Vector2 {
		guiPainterCursorPos.x + guiPainterControlSpacing.x,
		guiPainterCursorPos.y,
	}
	bounds := rl.Rectangle {
		position.x,
		guiPainterCursorPos.y,
		cast(f32)texture.width,
		cast(f32)texture.height,
	}
	GuiPainterAdvanceCursorLine(bounds)
	result := false
	if rl.GuiGetState() != cast(i32)rl.GuiState.STATE_DISABLED && !rl.GuiIsLocked() {
		mousePoint := rl.GetMousePosition()
		if (rl.CheckCollisionPointRec(mousePoint, bounds)) {
			if (rl.IsMouseButtonPressed(.LEFT)) do result = true
		}
	}
	rl.DrawTextureV(texture, position, tint)
	return result
}

GuiPainterImageRec :: proc(texture: rl.Texture, source: rl.Rectangle, tint: rl.Color) -> bool {
	position := rl.Vector2 {
		guiPainterCursorPos.x + guiPainterControlSpacing.x,
		guiPainterCursorPos.y,
	}
	bounds := rl.Rectangle{position.x, position.y, source.width, source.height}
	GuiPainterAdvanceCursorLine(bounds)
	result := false
	if rl.GuiGetState() != cast(i32)rl.GuiState.STATE_DISABLED && !rl.GuiIsLocked() {
		mousePoint := rl.GetMousePosition()
		if (rl.CheckCollisionPointRec(mousePoint, bounds)) {
			if (rl.IsMouseButtonPressed(.LEFT)) do result = true
		}
	}
	rl.DrawTextureRec(texture, source, position, tint)
	return result
}
