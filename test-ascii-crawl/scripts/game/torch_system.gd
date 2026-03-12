class_name TorchSystem
extends RefCounted

var torches: Array = []

func remove_torches_in_room() -> void:
	self.torches.clear()

func draw_torches_in_room(GRID_SIZE_COLS, GRID_SIZE_ROWS, num_of_torches) -> void:
		# Test torches
		if 1 == 1:
			var total_num_tiles = GRID_SIZE_COLS * GRID_SIZE_ROWS
			num_of_torches = randi() % (total_num_tiles / 450) + (total_num_tiles / 850)

		var torch_lst_rand = [
			[1, 1],
			[(GRID_SIZE_COLS * randf_range(.20, .30)), 1],
			[(GRID_SIZE_COLS * randf_range(.45, .55)), 1],
			[(GRID_SIZE_COLS * randf_range(.70, .80)), 1],
			[(GRID_SIZE_COLS - 2), 1],
			[1, GRID_SIZE_ROWS-2],
			[(GRID_SIZE_COLS * randf_range(.20, .30)), GRID_SIZE_ROWS-2],
			[(GRID_SIZE_COLS * randf_range(.45, .55)), GRID_SIZE_ROWS-2],
			[(GRID_SIZE_COLS * randf_range(.70, .80)), GRID_SIZE_ROWS-2],
			[(GRID_SIZE_COLS - 2), GRID_SIZE_ROWS-2],
			[1, (GRID_SIZE_ROWS-1) * randf_range(.25, .41)],
			[(GRID_SIZE_COLS * randf_range(.20, .30)), (GRID_SIZE_ROWS-1) * randf_range(.25, .41)],
			[(GRID_SIZE_COLS * randf_range(.45, .55)), (GRID_SIZE_ROWS-1) * randf_range(.25, .41)],
			[(GRID_SIZE_COLS * randf_range(.70, .80)), (GRID_SIZE_ROWS-1) * randf_range(.25, .41)],
			[(GRID_SIZE_COLS - 2), (GRID_SIZE_ROWS-1) * randf_range(.25, .41)],
			[1, (GRID_SIZE_ROWS-1) * randf_range(.58, .74)],
			[(GRID_SIZE_COLS * randf_range(.20, .30)), (GRID_SIZE_ROWS-1) * randf_range(.58, .74)],
			[(GRID_SIZE_COLS * randf_range(.45, .55)), (GRID_SIZE_ROWS-1) * randf_range(.58, .74)],
			[(GRID_SIZE_COLS * randf_range(.70, .80)), (GRID_SIZE_ROWS-1) * randf_range(.58, .74)],
			[(GRID_SIZE_COLS - 2), (GRID_SIZE_ROWS-1) * randf_range(.58, .74)]
		]

		for i in num_of_torches:
			var rand_i = randi() % torch_lst_rand.size()
			add_torch(torch_lst_rand[rand_i][0], torch_lst_rand[rand_i][1])
			torch_lst_rand.remove_at(rand_i)

func add_torch(col: int, row: int) -> void:
	torches.append({
		col   = col,
		row   = row,
		phase = randf() * TAU,
	})
	
	# Emit a 'torches_updated' signal for the new torch
	SignalBus.torches_updated.emit(torches)
