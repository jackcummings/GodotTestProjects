extends Node2D

# Get references to the camera
@onready var camera:    Camera2D    = $Camera2D

# Get references to ASCII Drawing layers
@onready var tile_render_node:    Node2D    = $TileLayer/TileLayerNode
@onready var entity_render_node:  Node2D    = $EntityLayer/EntityLayerNode

# Get references to Light layers
@onready var player_rect:  ColorRect = $EntityLightLayer/PlayerLightRect
@onready var torch_rect:   ColorRect = $EntityLightLayer/TorchLightRect

const GRID_SIZE_COLS = 80 
const GRID_SIZE_ROWS = 45

var tile_grid:	TileGrid
var player:	Player
var renderer:	Renderer
var torch_system:	TorchSystem
var lighting:	LightingSystem

func _ready() -> void:
	tile_grid = TileGrid.new(GRID_SIZE_COLS, GRID_SIZE_ROWS)
	player = Player.new(5, 5)
	renderer = Renderer.new()
	torch_system = TorchSystem.new()
	
	# Test room
	tile_grid.generate_simple_room()

	# Test torches
	torch_system.add_torch(1, 1)
	torch_system.add_torch(20, 1)
	torch_system.add_torch(40, 1)
	torch_system.add_torch(60, 1)
	torch_system.add_torch(78, 1)
	torch_system.add_torch(1, GRID_SIZE_ROWS-2)
	torch_system.add_torch(20, GRID_SIZE_ROWS-2)
	torch_system.add_torch(40, GRID_SIZE_ROWS-2)
	torch_system.add_torch(60, GRID_SIZE_ROWS-2)
	torch_system.add_torch(78, GRID_SIZE_ROWS-2)
	
	# Setup camera
	camera.setup(GRID_SIZE_COLS, GRID_SIZE_ROWS)
	tile_render_node.setup(renderer, tile_grid)
	entity_render_node.setup(renderer, player, torch_system)

	# Defer everything lighting-related until after the first frame to try and prevent
	# any graphical glitches from everything not being quite loaded
	call_deferred("_init_lighting")

func _init_lighting() -> void:
	lighting = LightingSystem.new(tile_render_node, player, player_rect, torch_rect,
								  renderer, torch_system)

	# Push current player position to global shaader variable player_screen_pos
	var player_position = renderer.player_screen_pos(tile_render_node, player)
	RenderingServer.global_shader_parameter_set("player_screen_pos", player_position)

func _process(delta: float) -> void:
	lighting.tick(delta)
	tile_render_node.redraw()
	entity_render_node.redraw()

func _unhandled_input(event: InputEvent) -> void:
	if not (event is InputEventKey and event.pressed):
		return
	const DIRECTIONS = {
		KEY_W: Vector2i(0, -1),  KEY_UP:    Vector2i(0, -1),
		KEY_S: Vector2i(0,  1),  KEY_DOWN:  Vector2i(0,  1),
		KEY_A: Vector2i(-1, 0),  KEY_LEFT:  Vector2i(-1, 0),
		KEY_D: Vector2i(1,  0),  KEY_RIGHT: Vector2i(1,  0),
	}
	if event.keycode in DIRECTIONS:
		var dir = DIRECTIONS[event.keycode]
		player.try_move(dir.x, dir.y, tile_grid)
