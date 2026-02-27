class_name TileGrid

enum Type { EMPTY, FLOOR, WALL }

var cols: int
var rows: int
var cells: Array = []

func _init(p_cols: int, p_rows: int) -> void:
	cols = p_cols
	rows = p_rows
	cells = []
	for r in rows:
		var row = []
		for c in cols:
			row.append(Type.EMPTY)
		cells.append(row)

func set_tile(col: int, row: int, type: Type) -> void:
	if in_bounds(col, row):
		cells[row][col] = type

func get_tile(col: int, row: int) -> Type:
	if in_bounds(col, row):
		return cells[row][col]
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
		set_tile(c, 0,        Type.WALL)
		set_tile(c, rows - 1, Type.WALL)
	for r in rows:
		set_tile(0,        r, Type.WALL)
		set_tile(cols - 1, r, Type.WALL)

func populate_simple_room_rocks(num_of_walls) -> void:
	for i in range(num_of_walls):
		set_tile((randi() % cols) + 1, (randi() % rows) + 1, Type.WALL)
