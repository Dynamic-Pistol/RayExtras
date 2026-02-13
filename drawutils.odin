package extra

//Extra drawing procs to aid in development

import "core:log"
import rl "vendor:raylib"
import rgl "vendor:raylib/rlgl"

//Draws a centered texture, doesn't use DrawTexturePro
DrawTextureCentered :: proc(texture: rl.Texture, position: rl.Vector2, tint: rl.Color) {
	if texture.id == 0 {
		log.errorf("Invalid Texture!")
        return
	}

	width := f32(texture.width)
	height := f32(texture.height)

	rgl.SetTexture(texture.id)
	rgl.Begin(rgl.QUADS)

	rgl.Color4f(f32(tint.r) / 255, f32(tint.g) / 255, f32(tint.b) / 255, f32(tint.a) / 255)

	// Top-left corner for texture and quad
	rgl.TexCoord2f(0, 0)
	rgl.Vertex2f(position.x - width / 2, position.y - height / 2)

	// Bottom-left corner for texture and quad
	rgl.TexCoord2f(0, 1)
	rgl.Vertex2f(position.x - width / 2, position.y + height / 2)

	// Bottom-right corner for texture and quad
	rgl.TexCoord2f(1, 1)
	rgl.Vertex2f(position.x + width / 2, position.y + height / 2)

	// Top-right corner for texture and quad
	rgl.TexCoord2f(1, 0)
	rgl.Vertex2f(position.x + width / 2, position.y - height / 2)

	rgl.End()
	rgl.SetTexture(0)

}

//Draws a centered texture with a source from a texture atlas
DrawTextureCenteredAtlased :: proc(
	texture: rl.Texture,
	source: rl.Rectangle,
	position: rl.Vector2,
	tint: rl.Color,
) {
	if texture.id == 0 {
		log.errorf("Invalid Texture!")
        return
	}

	width := f32(texture.width)
	height := f32(texture.height)

	rgl.SetTexture(texture.id)
	rgl.Begin(rgl.QUADS)

	rgl.Color4f(f32(tint.r) / 255, f32(tint.g) / 255, f32(tint.b) / 255, f32(tint.a) / 255)

	// Top-left corner for texture and quad
	rgl.TexCoord2f(source.x / width, source.y / height)
	rgl.Vertex2f(position.x - source.width / 2, position.y - source.height / 2)

	// Bottom-left corner for texture and quad
	rgl.TexCoord2f(source.x/width, (source.y + source.height)/height);
	rgl.Vertex2f(position.x - source.width / 2, position.y + source.height / 2)

	// Bottom-right corner for texture and quad
	rgl.TexCoord2f((source.x + source.width)/width, (source.y + source.height)/height);
	rgl.Vertex2f(position.x + source.width / 2, position.y + source.height / 2)

	// Top-right corner for texture and quad
	rgl.TexCoord2f((source.x + source.width)/width, source.y/height);
	rgl.Vertex2f(position.x + source.width / 2, position.y - source.height / 2)

	rgl.End()
	rgl.SetTexture(0)
}

//Basically 'DrawTexturePro' but with parameter defaults
DrawTextureOptions :: proc(texture: rl.Texture2D, source, dest: rl.Rectangle, origin: rl.Vector2 = {}, rotation: f32 = 0, tint: rl.Color = rl.WHITE) {
	rl.DrawTexturePro(texture, source, dest, origin, rotation, tint)
}