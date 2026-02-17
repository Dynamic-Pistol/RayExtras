package extra

import "core:math"
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

DrawTextureFlippedHorizontal :: proc(texture: rl.Texture, position: rl.Vector2, tint: rl.Color) {
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
	rgl.TexCoord2f(1, 0)
	rgl.Vertex2f(position.x - width / 2, position.y - height / 2)

	// Bottom-left corner for texture and quad
	rgl.TexCoord2f(1, 1)
	rgl.Vertex2f(position.x - width / 2, position.y + height / 2)

	// Bottom-right corner for texture and quad
	rgl.TexCoord2f(0, 1)
	rgl.Vertex2f(position.x + width / 2, position.y + height / 2)

	// Top-right corner for texture and quad
	rgl.TexCoord2f(0, 0)
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
	rgl.TexCoord2f(source.x / width, (source.y + source.height) / height)
	rgl.Vertex2f(position.x - source.width / 2, position.y + source.height / 2)

	// Bottom-right corner for texture and quad
	rgl.TexCoord2f((source.x + source.width) / width, (source.y + source.height) / height)
	rgl.Vertex2f(position.x + source.width / 2, position.y + source.height / 2)

	// Top-right corner for texture and quad
	rgl.TexCoord2f((source.x + source.width) / width, source.y / height)
	rgl.Vertex2f(position.x + source.width / 2, position.y - source.height / 2)

	rgl.End()
	rgl.SetTexture(0)
}

//Basically 'DrawTexturePro' but with parameter defaults
DrawTextureOptions :: proc(
	texture: rl.Texture2D,
	source, dest: rl.Rectangle,
	origin: rl.Vector2 = {},
	rotation: f32 = 0,
	tint: rl.Color = rl.WHITE,
) {
	rl.DrawTexturePro(texture, source, dest, origin, rotation, tint)
}

TextureFlip :: enum u8 {
	X,
	Y,
}

TextureFlips :: bit_set[TextureFlip;u8]

DrawTextureMega :: proc(
	texture: rl.Texture,
	dest: rl.Rectangle,
	atlas: Maybe(rl.Rectangle) = nil,
	origin: rl.Vector2 = {},
	rotation: f32 = 0,
	flips: TextureFlips = {},
	tint := rl.WHITE,
) {
	// Check if texture is valid
	if texture.id <= 0 {
		log.errorf("Invalid texture!")
		return
	}

	width := f32(texture.width)
	height := f32(texture.height)

	source: rl.Rectangle = atlas.(rl.Rectangle) or_else {0, 0, width, height}

	if source.width < 0 || source.height < 0 {
		log.errorf("Don't flip via negative source! use flips parameters")
		return
	}

	if dest.width < 0 || dest.height < 0 {
		log.errorf("Invalid destination size!")
		return
	}

	topLeft: rl.Vector2 = 0
	topRight: rl.Vector2 = 0
	bottomLeft: rl.Vector2 = 0
	bottomRight: rl.Vector2 = 0

	// Only calculate rotation if needed
	if rotation == 0 {
		x := dest.x - origin.x
		y := dest.y - origin.y
		topLeft = {x, y}
		topRight = {x + dest.width, y}
		bottomLeft = {x, y + dest.height}
		bottomRight = {x + dest.width, y + dest.height}
	} else {
		sinRotation := math.sin(rotation * rl.DEG2RAD)
		cosRotation := math.cos(rotation * rl.DEG2RAD)
		x := dest.x
		y := dest.y
		dx := -origin.x
		dy := -origin.y

		topLeft.x = x + dx * cosRotation - dy * sinRotation
		topLeft.y = y + dx * sinRotation + dy * cosRotation

		topRight.x = x + (dx + dest.width) * cosRotation - dy * sinRotation
		topRight.y = y + (dx + dest.width) * sinRotation + dy * cosRotation

		bottomLeft.x = x + dx * cosRotation - (dy + dest.height) * sinRotation
		bottomLeft.y = y + dx * sinRotation + (dy + dest.height) * cosRotation

		bottomRight.x = x + (dx + dest.width) * cosRotation - (dy + dest.height) * sinRotation
		bottomRight.y = y + (dx + dest.width) * sinRotation + (dy + dest.height) * cosRotation
	}

	rgl.SetTexture(texture.id)
	rgl.Begin(rgl.QUADS)

	rgl.Color4ub(tint.r, tint.g, tint.b, tint.a)
	rgl.Normal3f(0, 0, 1) // Normal vector pointing towards viewer

	// Top-left corner for texture and quad
	rgl.TexCoord2f(
		.X in flips ? (source.x + source.width) / width : source.x / width,
		.Y in flips ? (source.y + source.height) / height : source.y / height,
	)
	rgl.Vertex2f(topLeft.x, topLeft.y)

	// Bottom-left corner for texture and quad
	rgl.TexCoord2f(
		.X in flips ? (source.x + source.width) / width : source.x / width,
		.Y in flips ? source.y / height : (source.y + source.height) / height,
	)
	rgl.Vertex2f(bottomLeft.x, bottomLeft.y)

	// Bottom-right corner for texture and quad
	rgl.TexCoord2f(
		.X in flips ? source.x / width : (source.x + source.width) / width,
		.Y in flips ? source.y / height : (source.y + source.height) / height,
	)
	rgl.Vertex2f(bottomRight.x, bottomRight.y)

	// Top-right corner for texture and quad
	rgl.TexCoord2f(
		.X in flips ? source.x / width : (source.x + source.width) / width,
		.Y in flips ? (source.y + source.height) / height : source.y / height,
	)
	rgl.Vertex2f(topRight.x, topRight.y)

	rgl.End()
	rgl.SetTexture(0)

}
