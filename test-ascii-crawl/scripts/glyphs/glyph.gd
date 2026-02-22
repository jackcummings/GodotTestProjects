# A 'glyph', which is a string/character + a color.  The game world graphics (tiles/entities/etc) 
# are made of glyphs. These are used by game_glyphs for the different tile/graphics used in the
# game.  Check out the data/glyphs.tres
class_name Glyph
extends Resource

@export var glyph: String = "?"
@export var color: Color  = Color.WHITE
