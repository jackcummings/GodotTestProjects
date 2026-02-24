class_name Renderer

var font:   Font
var glyphs: GameGlyphs

var tile_width : int
var tile_height : int
var font_size : int

func _init(p_tile_width: int, p_tile_height: int, p_font_size: int, p_glyphs_path: String) -> void:
	font   = ThemeDB.fallback_font
	tile_width = p_tile_width
	tile_height = p_tile_height
	font_size = p_font_size
	glyphs = load(p_glyphs_path)

# -------------------------------------------------- 
# --- Helper functions to convert grid to pixels ---
# -------------------------------------------------- 

func player_screen_pos(canvas: Node2D, player: Player) -> Vector2:
	# Use visual_pos (the tweened pixel position) so the player light
	# follows the smooth movement rather than snapping grid-to-grid.
	var local_center = player.visual_pos + (Vector2(tile_width, tile_height) * 0.5)
	return canvas.get_viewport().get_canvas_transform() \
		 * canvas.get_global_transform() \
		 * local_center

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
	# Draw at visual_pos (pixel) rather than snapping to grid col/row
	_draw_glyph_at_pixel(canvas, player.visual_pos, glyphs.player)

# Draws a filled, black square over the tile & then draws a character on top
func _draw_glyph(canvas: Node2D, col: int, row: int, glyph: Glyph) -> void:
	var pos = Utilities.grid_to_pixel(col, row)
	canvas.draw_rect(Rect2(pos, Vector2(tile_width, tile_height)),
					 Color.BLACK)
	canvas.draw_string(font, pos + Vector2(2, tile_height - 2),
					   glyph.glyph,
					   HORIZONTAL_ALIGNMENT_LEFT, -1,
					   font_size, glyph.color)

# Pixel-position variant used for smoothly-moving entities
func _draw_glyph_at_pixel(canvas: Node2D, pos: Vector2, glyph: Glyph) -> void:
	canvas.draw_rect(Rect2(pos, Vector2(tile_width, tile_height)),
					 Color.BLACK)
	canvas.draw_string(font, pos + Vector2(2, tile_height - 2),
					   glyph.glyph,
					   HORIZONTAL_ALIGNMENT_LEFT, -1,
					   font_size, glyph.color)					
