# This is used for the different tiles/graphics in the game.  This script is 
# hooked to the resource glyphs.tres, which allows in-editor custom changes.
class_name GameGlyphs
extends Resource

# Tiles
@export var floor: Glyph = Glyph.new()
@export var wall:  Glyph = Glyph.new()
@export var empty: Glyph = Glyph.new()

# Entities
@export var player: Glyph = Glyph.new()
@export var torch:  Glyph = Glyph.new()

# Convenience lookup by TileGrid.Type enum
func for_tile(type: TileGrid.Type) -> Glyph:
	match type:
		TileGrid.Type.FLOOR: return floor
		TileGrid.Type.WALL:  return wall
		_:                  return empty
