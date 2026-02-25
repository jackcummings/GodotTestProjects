class_name Player

var col: int
var row: int

# Visual (pixel) position used by the renderer for drawing.
# This is tweened toward the logical tile position each frame,
# creating smooth movement between cells.
var visual_pos: Vector2

# Tween state 
# - tween_from/to is the current player position vs the target position.
# - tween_t will be between 0 and 1.0 when the tween 'animation' is playing, 1.0 being done
# - tween_dur is how long this tween 'animation' should last.
var _tween_from: Vector2
var _tween_to:   Vector2
var _tween_t:    float = 1.0   # 0.0 = start, 1.0 = done
var _tween_dur:  float = 0.10  # seconds for tweening movement duration

func _init(start_col: int, start_row: int) -> void:
	col = start_col
	row = start_row
	visual_pos = Utilities.grid_to_pixel(col, row)
	_tween_to  = visual_pos
	_tween_from = visual_pos
	
func try_move(direction_col: int, direction_row: int, tile_grid: TileGrid) -> void:
	var new_col = col + direction_col
	var new_row = row + direction_row
	if tile_grid.is_walkable(new_col, new_row):
		col = new_col
		row = new_row
		# Snap tween_from to current visual pos so chained moves feel responsive
		_tween_from = visual_pos
		_tween_to   = Utilities.grid_to_pixel(col, row)
		_tween_t    = 0.0
		SignalBus.player_moved.emit(col, row)

# Call this every frame from main._process() before redrawing.
func tick(delta: float) -> void:
	if _tween_t >= 1.0:
		return
	_tween_t   = minf(_tween_t + delta / _tween_dur, 1.0)
	var ease_t = Utilities.ease_out_cubic(_tween_t)
	visual_pos = _tween_from.lerp(_tween_to, ease_t)
