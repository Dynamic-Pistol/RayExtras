//This File allows you to embed data into your game binary, most of these require the file format because raylib can't autodetect it for some reason
package extra

import rl "vendor:raylib"

//Embeds a texture into your binary
@(require_results)
PreLoadTexture :: proc($imagePath: string, format: cstring = ".png") -> rl.Texture {
	data := #load(imagePath)
	image := rl.LoadImageFromMemory(format, raw_data(data), i32(len(data)))
	rl.LoadTextureFromImage(image)
	texture := rl.LoadTextureFromImage(image)
	rl.UnloadImage(image)
	return texture
}

//Embeds music into your binary
@(require_results)
PreLoadMusic :: proc($musicPath: string, format: cstring = ".wav") -> rl.Music {
	data := #load(musicPath)
	music := rl.LoadMusicStreamFromMemory(format, raw_data(data), i32(len(data)))
	return music
}

//Embeds a font into your binary
PreLoadFont :: proc($fontPath: string, format: cstring = ".ttf", size: i32 = 20) -> rl.Font {
	data := #load(fontPath)
	font := rl.LoadFontFromMemory(format, raw_data(data), i32(len(data)), size, nil, 0)
	return font
}
