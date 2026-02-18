extends Node2D

# The '..' is a path that means the parent node, so we can access it
@onready var tile_grid: Node2D = $".." 

# Player start position in 'TileGrid coordinates'
var player_col: int = 5
var player_row: int = 5
const PLAYER_GLYPH = "@"

func _ready() -> void:
	pass

func _draw() -> void:
	var font      = ThemeDB.fallback_font
	var font_size = tile_grid.TILE_H
	var pos       = Vector2(player_col * tile_grid.TILE_W,
							player_row * tile_grid.TILE_H)

	draw_string(font, pos + Vector2(2, font_size - 2), PLAYER_GLYPH,
				HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, Color.YELLOW)

# There is probably a better way to do this player input than this...
func _unhandled_input(event: InputEvent) -> void: 
	if event is InputEventKey and event.pressed:
		var new_col = player_col
		var new_row = player_row

		match event.keycode:
			KEY_W, KEY_UP:    new_row -= 1
			KEY_S, KEY_DOWN:  new_row += 1
			KEY_A, KEY_LEFT:  new_col -= 1
			KEY_D, KEY_RIGHT: new_col += 1

		# Make sure tile type is walkable
		if tile_grid.get_tile(new_col, new_row) == tile_grid.TileType.FLOOR:
			player_col = new_col
			player_row = new_row
			queue_redraw()
		
		print("x: ", player_col, "\ny: ", player_row)
