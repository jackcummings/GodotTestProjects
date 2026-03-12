class_name TileGrid
extends RefCounted

# Public Variables
enum Type { EMPTY, FLOOR, WALL }

var cols: int
var rows: int

# Private Variables
var _cells: Array = []

func _init(p_cols: int, p_rows: int) -> void:
	cols = p_cols
	rows = p_rows
	_cells = []
	for r in rows:
		var row = []
		for c in cols:
			row.append(Type.EMPTY)
		_cells.append(row)

func set_tile(col: int, row: int, type: Type) -> void:
	if in_bounds(col, row):
		_cells[row][col] = type

func get_tile(col: int, row: int) -> Type:
	if in_bounds(col, row):
		return _cells[row][col]
	return Type.EMPTY

func is_walkable(col: int, row: int) -> bool:
	return get_tile(col, row) == Type.FLOOR

func in_bounds(col: int, row: int) -> bool:
	return col >= 0 and col < cols and row >= 0 and row < rows

# ------------------
# --- Generation ---
# ------------------

func generate_simple_room() -> void:
	for r in range(1, rows - 1):
		for c in range(1, cols - 1):
			set_tile(c, r, Type.FLOOR)
	for c in cols:
		set_tile(c, 0,			Type.WALL)
		set_tile(c, rows - 1,	Type.WALL)
	for r in rows:		
		set_tile(0, r,			Type.WALL)
		set_tile(cols - 1, r,	Type.WALL)

func populate_simple_room_rocks(num_of_walls: int, player: Player) -> void:
	var player_pos: Vector2i = player.get_player_pos()
	for i in range(num_of_walls):
		var r_col = (randi() % cols) + 1
		var r_row = (randi() % rows) + 1
		
		while(get_tile(r_col, r_row) != Type.FLOOR 
			  and (r_col != player_pos.x and r_row != player_pos.y)):
			r_col = (randi() % cols) + 1
			r_row = (randi() % rows) + 1
			
		set_tile(r_col, r_row, Type.WALL)
