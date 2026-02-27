class_name EntityList

var entity_lst: Array = []

# func _init() -> void:

func add(col: int, row: int, entity: entity) -> void:
	entity_lst.append({
		col   = col,
		row   = row,
		entity = entity
	})

func draw(entity: e) -> void:
	pass
