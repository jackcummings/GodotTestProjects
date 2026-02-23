class_name TorchSystem

const BASE_RADIUS    = 260.0
const FLICKER_AMOUNT = 28.0
const FLICKER_SPEED  = 2.6

var torches: Array = []

# Emits a 'torches_updated' signal, which is only connected to the LightingSystem (lighting.gd)
# currently.  The lighting then updates the animated radius varible & updates the shader variables.
func update() -> void:
	if torches.is_empty():
		return
	SignalBus.torches_updated.emit(torches)

func remove_torches_in_room() -> void:
	self.torches.clear()

func draw_torches_in_room(GRID_SIZE_COLS, GRID_SIZE_ROWS, num_of_torches) -> void:
		# Test torches
		var torch_lst = [
			[1, 1],
			[20, 1],
			[40, 1],
			[60, 1],
			[78, 1],
			[1, GRID_SIZE_ROWS-2],
			[20, GRID_SIZE_ROWS-2],
			[40, GRID_SIZE_ROWS-2],
			[60, GRID_SIZE_ROWS-2],
			[78, GRID_SIZE_ROWS-2],
			[1, (GRID_SIZE_ROWS-1) * (.33)],
			[20, (GRID_SIZE_ROWS-1) * (.33)],
			[40, (GRID_SIZE_ROWS-1) * (.33)],
			[60, (GRID_SIZE_ROWS-1) * (.33)],
			[78, (GRID_SIZE_ROWS-1) * (.33)],
			[1, (GRID_SIZE_ROWS-1) * (.66)],
			[20, (GRID_SIZE_ROWS-1) * (.66)],
			[40, (GRID_SIZE_ROWS-1) * (.66)],
			[60, (GRID_SIZE_ROWS-1) * (.66)],
			[78, (GRID_SIZE_ROWS-1) * (.66)]
		]

		for i in num_of_torches:
			var rand_i = randi() % torch_lst.size()
			add_torch(torch_lst[rand_i][0], torch_lst[rand_i][1])
			torch_lst.remove_at(rand_i)


func add_torch(col: int, row: int) -> void:
	torches.append({
		col   = col,
		row   = row,
		phase = randf() * TAU,
	})
	
	# Emit a 'torches_updated' signal for the new torch
	SignalBus.torches_updated.emit(torches)

# AI did this 'animation'... probably could be better
func animated_radius(torch: Dictionary, elapsed: float) -> float:
	var noise = sin(elapsed * FLICKER_SPEED + torch.phase) * 0.6 \
			  + sin(elapsed * FLICKER_SPEED * 2.3 + torch.phase) * 0.3 \
			  + sin(elapsed * FLICKER_SPEED * 5.1 + torch.phase) * 0.1
	return BASE_RADIUS + noise * FLICKER_AMOUNT
