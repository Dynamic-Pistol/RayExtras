//Function to draw with optional parameters hassle free
package extra

import "core:log"
import "core:math"
import rl "vendor:raylib"
import rgl "vendor:raylib/rlgl"

TextureFlip :: enum u8 {
	X,
	Y,
}

TextureFlips :: bit_set[TextureFlip;u8]


DrawTextureBetterRect :: proc(
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

DrawTextureMega :: proc(
	texture: rl.Texture,
	position: rl.Vector2,
	atlas: Maybe(rl.Rectangle) = nil,
	origin: rl.Vector2 = {},
	rotation: f32 = 0,
	scale: rl.Vector2 = 1,
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

	dest := rl.Rectangle{position.x, position.y, width * scale.x, height * scale.y}

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
