package extra

//This File allows you to embed data into your game binary, most of these require the file format because raylib can't autodetect it for some reason

import "core:c"
import rl "vendor:raylib"

//Embeds a texture into your binary
@(require_results)
PreLoadTexture :: proc($imagePath: string, format: cstring = ".png") -> rl.Texture {
	DATA :: #load(imagePath)
	image := rl.LoadImageFromMemory(format, raw_data(DATA), i32(len(DATA)))
	rl.LoadTextureFromImage(image)
	texture := rl.LoadTextureFromImage(image)
	rl.UnloadImage(image)
	return texture
}

//Embeds music into your binary
@(require_results)
PreLoadMusic :: proc($imagePath: string, format: cstring = ".wav") -> rl.Music {
	DATA :: #load(imagePath)
	music := rl.LoadMusicStreamFromMemory(format, raw_data(DATA), i32(len(DATA)))
	return music
}

//Embeds a font into your binary
PreLoadFont ::  proc($imagePath: string, format: cstring = ".ttf", size: c.int = 20) -> rl.Font {
	DATA :: #load(imagePath)
	font := rl.LoadFontFromMemory(format, raw_data(DATA), i32(len(DATA)), size, nil, 0)
	return font
}