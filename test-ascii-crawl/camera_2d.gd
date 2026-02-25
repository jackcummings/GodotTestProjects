class_name GameCamera
extends Camera2D

# Tween state 
# - tween_from/to is the current player position vs the target position.
# - tween_t will be between 0 and 1.0 when the tween 'animation' is playing, 1.0 being done
# - tween_dur is how long the camera takes to reach the player's tile when it is moving.
# -- A slightly longer duration than the player tween (0.10s) gives a nice feel
var _tween_from: Vector2
var _tween_to:   Vector2
var _tween_t:    float = 1.0
var _tween_dur = 0.2

func setup(grid_cols: int, grid_rows: int) -> void:
	var limits = Utilities.grid_to_pixel(grid_cols, grid_rows)
	
	limit_left   = 0
	limit_top    = 0
	limit_right  = limits.x
	limit_bottom = limits.y

	SignalBus.player_moved.connect(_on_player_moved)

# When player moves, set the 'tween from' position to the current camera position,
# and the 'tween to' to 
func _on_player_moved(col: int, row: int) -> void:
	_tween_from = position
	_tween_to = Utilities.grid_center_to_pixel(col, row)
	_tween_t = 0.0

func _process(delta: float) -> void:
	if _tween_t >= 1.0:
		return
	_tween_t  = minf(_tween_t + delta / _tween_dur, 1.0)
	position  = _tween_from.lerp(_tween_to, Utilities.ease_out_cubic(_tween_t))
