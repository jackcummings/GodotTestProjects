class_name Renderer

const TILE_W    = 16
const TILE_H    = 16
const FONT_SIZE = TILE_H

const GLYPHS_PATH = "res://data/glyphs.tres"

var font:   Font
var glyphs: GameGlyphs

func _init() -> void:
	font   = ThemeDB.fallback_font
	glyphs = load(GLYPHS_PATH)

# -------------------------------------------------- 
# --- Helper functions to convert grid to pixels ---
# -------------------------------------------------- 

func tile_to_local(col: int, row: int) -> Vector2:
	return Vector2(col * TILE_W, row * TILE_H)

# Function to get the center of tile in screen/pixel space, needed for shaders. 
# (Transform stuff is to accurately map position in local space to screen (pixel) space,
# based on 
func tile_to_screen(canvas: Node2D, col: int, row: int) -> Vector2:
	var local_center = tile_to_local(col, row) + Vector2(TILE_W, TILE_H) * 0.5
	return canvas.get_viewport().get_canvas_transform() \
		 * canvas.get_global_transform() \
		 * local_center

func player_screen_pos(canvas: Node2D, player: Player) -> Vector2:
	return tile_to_screen(canvas, player.col, player.row)

# ------------------
# --- Draw calls ---
# ------------------

func draw_tiles(canvas: Node2D, tile_grid: TileGrid) -> void:
	for r in tile_grid.rows:
		for c in tile_grid.cols:
			_draw_glyph(canvas, c, r, glyphs.for_tile(tile_grid.get_tile(c, r)))

func draw_entities(canvas: Node2D, player: Player,
				   torch_system: TorchSystem) -> void:
	_draw_torches(canvas, torch_system)
	_draw_player(canvas, player)

func _draw_torches(canvas: Node2D, torch_system: TorchSystem) -> void:
	for t in torch_system.torches:
		_draw_glyph(canvas, t.col, t.row, glyphs.torch)

func _draw_player(canvas: Node2D, player: Player) -> void:
	_draw_glyph(canvas, player.col, player.row, glyphs.player)

# Draws a filled, black square over the tile & then draws a character on top
func _draw_glyph(canvas: Node2D, col: int, row: int, glyph: Glyph) -> void:
	var pos = tile_to_local(col, row)
	canvas.draw_rect(Rect2(pos, Vector2(TILE_W, TILE_H)), Color.BLACK)
	canvas.draw_string(font, pos + Vector2(2, TILE_H - 2),
					   glyph.glyph,
					   HORIZONTAL_ALIGNMENT_LEFT, -1,
					   FONT_SIZE, glyph.color)
