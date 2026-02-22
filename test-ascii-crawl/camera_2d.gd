class_name GameCamera
extends Camera2D

const TILE_W = Renderer.TILE_W
const TILE_H = Renderer.TILE_H

# Setup camera and connect the track_player function to the
# 'player_moved' signal, which is emitted by player.gd under
# try_move()
func setup(grid_cols: int, grid_rows: int) -> void:
	# Clamp camera so it never shows outside the grid
	limit_left   = 0
	limit_top    = 0
	limit_right  = grid_cols * TILE_W
	limit_bottom = grid_rows * TILE_H
	
	SignalBus.player_moved.connect(track_player)

# Shift the camera position to follow the player (unless it runs into the
# clamps set above)
func track_player(_col: int, _row: int) -> void:
	# Center the camera on the player's tile (pixel center of that tile)
	position = Vector2(
		_col * TILE_W + TILE_W * 0.5,
		_row * TILE_H + TILE_H * 0.5
	)
