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
