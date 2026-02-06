package extra

import rl "vendor:raylib"

DrawGameLetterBox :: proc(gameScreen: rl.RenderTexture) {
	screenWidth, screenHeight := f32(rl.GetScreenWidth()), f32(rl.GetScreenHeight())
	gameWidth, gameHeight := f32(gameScreen.texture.width), f32(gameScreen.texture.height)
	scale := min(screenWidth / gameWidth, screenHeight / gameHeight)

	// Apply the same transformation as the virtual mouse to the real mouse (i.e. to work with raygui)
	rl.SetMouseOffset(
		-(rl.GetScreenWidth() - i32(gameWidth * scale)) / 2,
		-(rl.GetScreenHeight() - i32(gameHeight * scale)) / 2,
	)
	rl.SetMouseScale(1 / scale, 1 / scale)

	rl.DrawTexturePro(
		gameScreen.texture,
		{0, 0, f32(gameWidth), f32(-gameHeight)},
		{
			(screenWidth - gameWidth * scale) * 0.5,
			(screenHeight - gameHeight * scale) * 0.5,
			(gameWidth * scale),
			(gameHeight * scale),
		},
		{},
		0,
		rl.WHITE,
	)

}
