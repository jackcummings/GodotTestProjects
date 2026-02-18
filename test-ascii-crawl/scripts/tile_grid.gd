extends Node2D

# --- Configuration ---
@export var COLS = 80
@export var ROWS = 24
const TILE_W = 16   
const TILE_H = 16

# Different types of tiles
enum TileType { FLOOR, WALL, EMPTY }

# ASCII characters
const TILE_GLYPH = {
	TileType.FLOOR: ".",
	TileType.WALL:  "#",
	TileType.EMPTY: " ",
}

# Color per tile type
const TILE_COLOR = {
	TileType.FLOOR: Color(0.5, 0.5, 0.5),
	TileType.WALL:  Color(0.8, 0.8, 0.8),
	TileType.EMPTY: Color(0, 0, 0),
}

var grid: Array = []   # 2D array [row][col], initialized with TileType values in _init_grid()
var font: Font

func _ready() -> void:
	font = ThemeDB.fallback_font    # use Godot's built-in monospace fallback
	_init_grid()
	_generate_simple_room()
	queue_redraw()

# -------------------------------------------------------
# Grid helpers
# -------------------------------------------------------

func _init_grid() -> void:
	grid = []
	for r in ROWS:
		var row = []
		for c in COLS:
			row.append(TileType.EMPTY)
		grid.append(row)

func set_tile(col: int, row: int, type: TileType) -> void:
	if _in_bounds(col, row):
		grid[row][col] = type
		queue_redraw()

func get_tile(col: int, row: int) -> TileType:
	if _in_bounds(col, row):
		return grid[row][col]
	return TileType.EMPTY

func _in_bounds(col: int, row: int) -> bool:
	return col >= 0 and col < COLS and row >= 0 and row < ROWS

# -------------------------------------------------------
# Rendering
# -------------------------------------------------------

func _draw() -> void:
	var font_size = TILE_H

	for r in ROWS:
		for c in COLS:
			var tile  = grid[r][c]
			var glyph = TILE_GLYPH[tile]
			var color = TILE_COLOR[tile]
			var pos   = Vector2(c * TILE_W, r * TILE_H)

			# Optional: draw a black background cell
			draw_rect(Rect2(pos, Vector2(TILE_W, TILE_H)), Color.BLACK)

			# Draw the ASCII character
			draw_string(font, pos + Vector2(2, TILE_H - 2), glyph,
						HORIZONTAL_ALIGNMENT_LEFT, -1, font_size, color)

# -------------------------------------------------------
# Test room
# -------------------------------------------------------

func _generate_simple_room() -> void:
	# Fill interior with floor
	for r in range(1, ROWS - 1):
		for c in range(1, COLS - 1):
			grid[r][c] = TileType.FLOOR

	# Draw walls around the border
	for c in COLS:
		grid[0][c]        = TileType.WALL
		grid[ROWS - 1][c] = TileType.WALL
	for r in ROWS:
		grid[r][0]        = TileType.WALL
		grid[r][COLS - 1] = TileType.WALL
