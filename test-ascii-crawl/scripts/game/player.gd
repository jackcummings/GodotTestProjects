class_name Player

var col: int
var row: int

func _init(start_col: int, start_row: int) -> void:
	col = start_col
	row = start_row

func try_move(dc: int, dr: int, tile_grid: TileGrid) -> void:
	var new_col = col + dc
	var new_row = row + dr
	if tile_grid.is_walkable(new_col, new_row):
		col = new_col
		row = new_row
		SignalBus.player_moved.emit(col, row)
