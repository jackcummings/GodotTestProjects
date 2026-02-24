class_name GameCamera
extends Camera2D

var current_tile_width = GlobalData.tile_width
var current_tile_height = GlobalData.tile_height

# How long the camera takes to reach the player's tile. 
# A slightly longer duration than the player tween (0.10s) gives a nice
# "camera catches up" feel. Tweak to taste.
const TWEEN_DUR = 0.18

var _tween_from: Vector2
var _tween_to:   Vector2
var _tween_t:    float = 1.0

func setup(grid_cols: int, grid_rows: int) -> void:
	limit_left   = 0
	limit_top    = 0
	limit_right  = grid_cols * current_tile_width
	limit_bottom = grid_rows * current_tile_height

	SignalBus.player_moved.connect(_on_player_moved)

# When player moves, set the 'tween from' position to the current camera position,
# and the 'tween to' to 
func _on_player_moved(col: int, row: int) -> void:
	_tween_from = position
	_tween_to   = Utilities.grid_center_to_pixel(col, row)
	_tween_t = 0.0

func _process(delta: float) -> void:
	if _tween_t >= 1.0:
		return
	_tween_t  = minf(_tween_t + delta / TWEEN_DUR, 1.0)
	position  = _tween_from.lerp(_tween_to, _ease_out_cubic(_tween_t))

func _ease_out_cubic(t: float) -> float:
	return 1.0 - pow(1.0 - t, 3.0)
