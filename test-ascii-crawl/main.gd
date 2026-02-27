extends Node2D

# Get references to the camera
@onready var camera:    Camera2D    = $Camera2D

# Get references to ASCII Drawing layers
@onready var tile_render_node:    Node2D    = $TileLayer/TileLayerNode
@onready var entity_render_node:  Node2D    = $EntityLayer/EntityLayerNode

# Get references to Light layers
@onready var player_rect:  ColorRect = $EntityLightLayer/PlayerLightRect
@onready var torch_rect:   ColorRect = $EntityLightLayer/TorchLightRect

var tile_grid:	TileGrid
var player:	Player
var renderer:	Renderer
var torch_system:	TorchSystem
var lighting:	LightingSystem
var num_of_torches = 7 # Not currently used as it is calculated by room size
var num_of_walls = 100

func _ready() -> void:
	tile_grid = TileGrid.new(GlobalData.grid_size_cols, 
							 GlobalData.grid_size_rows)
	renderer = Renderer.new(GlobalData.tile_width, 
							GlobalData.tile_height, 
							GlobalData.font_size, 
							GlobalData.GLYPHS_PATH)
	player = Player.new(5, 5)
	torch_system = TorchSystem.new()
	
	# Test room
	tile_grid.generate_simple_room()
	tile_grid.populate_simple_room_rocks(num_of_walls)

	# Test torches
	torch_system.draw_torches_in_room(GRID_SIZE_COLS, GRID_SIZE_ROWS, num_of_torches)

	# Test entity
	

	# Setup camera
	camera.setup(GlobalData.grid_size_cols, GlobalData.grid_size_rows)
	tile_render_node.setup(renderer, tile_grid)
	entity_render_node.setup(renderer, player, torch_system)

	# Defer everything lighting-related until after the first frame to try and prevent
	# any graphical glitches from everything not being quite loaded
	call_deferred("_init_lighting")

func _init_lighting() -> void:
	lighting = LightingSystem.new(tile_render_node, player, player_rect, torch_rect, torch_system)

	# Push current player position to global shaader variable player_screen_pos
	var player_position = renderer.player_screen_pos(tile_render_node, player)
	RenderingServer.global_shader_parameter_set("player_screen_pos", player_position)

func _process(delta: float) -> void:
	# Tick the player tween first so visual_pos is fresh before any draw calls
	player.tick(delta)

	# Keep player light shader in sync with the smooth visual position every frame
	# (previously this only updated on the player_moved signal, which caused snapping)
	#var player_position = renderer.player_screen_pos(tile_render_node, player)
	#RenderingServer.global_shader_parameter_set("player_screen_pos", player_position)
	
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
		
	if event.keycode == KEY_R:
		torch_system.remove_torches_in_room()
		torch_system.draw_torches_in_room(GRID_SIZE_COLS, GRID_SIZE_ROWS, num_of_torches)
