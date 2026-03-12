extends Node2D

@onready var game_viewport_container: SubViewportContainer = $GameViewportContainer
@onready var game_viewport:           SubViewport          = $GameViewportContainer/GameViewport

# Get references to the camera
@onready var camera: Camera2D = $GameViewportContainer/GameViewport/Camera2D

# Get references to ASCII Drawing layers
@onready var tile_render_node:   Node2D    = $GameViewportContainer/GameViewport/TileLayer/TileLayerNode
@onready var entity_render_node: Node2D    = $GameViewportContainer/GameViewport/EntityLayer/EntityLayerNode

# Get references to Light layers
@onready var player_rect:        ColorRect = $GameViewportContainer/GameViewport/EntityLightLayer/PlayerLightRect
@onready var torch_rect:         ColorRect = $GameViewportContainer/GameViewport/EntityLightLayer/TorchLightRect

# Get references to ASCII UI layer
@onready var ui_render_node: Node2D = $UILayer/UILayerNode

var tile_grid:			TileGrid
var player:				Player
var glyphs: 			GameGlyphs
var renderer:			Renderer
var torch_system:		TorchSystem
var lighting:			LightingSystem
var player_settings:	PlayerSettings
var torch_settings:		TorchSettings
var renderer_ui:		RendererUI
var resize_handler: 	ResizeHandler
var panel_settings:		UISettings

var num_of_torches = 7 # Not currently used as it is calculated by room size
var num_of_walls = 100

func _ready() -> void:
	glyphs = load(GlobalData.GLYPHS_PATH)
	tile_grid = TileGrid.new(GlobalData.grid_size_cols, 
							 GlobalData.grid_size_rows)
	renderer = Renderer.new(glyphs,
							GlobalData.tile_width, 
							GlobalData.tile_height, 
							GlobalData.font_size, 
							GlobalData.GLYPHS_PATH)
	player = Player.new(5, 5)
	torch_system = TorchSystem.new()
	player_settings = load(GlobalData.PLAYER_SETTINGS_PATH)
	torch_settings = load(GlobalData.TORCH_SETTINGS_PATH)
	_setup_ui()
	# Test room
	tile_grid.generate_simple_room()
	tile_grid.populate_simple_room_rocks(num_of_walls, player)

	# Test torches
	torch_system.draw_torches_in_room(GlobalData.grid_size_cols, GlobalData.grid_size_rows, num_of_torches)

	# Test entity
	
	# Setup camera
	camera.setup(GlobalData.grid_size_cols, GlobalData.grid_size_rows)
	tile_render_node.setup(renderer, tile_grid)
	entity_render_node.setup(renderer, player, torch_system)

	# Defer everything lighting-related until after the first frame to try and prevent
	# any graphical glitches from everything not being quite loaded
	call_deferred("_init_lighting")

func _setup_ui() -> void:
	renderer_ui = RendererUI.new(GlobalData.tile_width, GlobalData.tile_height, GlobalData.font_size)
	panel_settings = load(GlobalData.UI_SETTINGS_PATH)
	# Instantiate panels — each is self-contained.
	var stats_panel = StatsPanel.new(player, panel_settings, 1, 1)
	var log_panel   = MessageLogPanel.new( panel_settings, 1, 10, 24, 5)

	# Setup UI panels & the resize handler
	ui_render_node.setup(renderer_ui, panel_settings, [stats_panel, log_panel])
	resize_handler = ResizeHandler.new(self, ui_render_node, game_viewport, 
									   game_viewport_container, panel_settings)

	SignalBus.log_message.emit("You descend into the dark, dark, dark, dark, dark, dungeon.")
	
func _init_lighting() -> void:
	lighting = LightingSystem.new(tile_render_node, player, player_settings, 
								  torch_settings, player_rect, torch_rect, 
								  torch_system, glyphs)

	# Push current player position to global shaader variable player_screen_pos
	var player_position = renderer.player_screen_pos(tile_render_node, player)
	RenderingServer.global_shader_parameter_set("player_screen_pos", player_position)
	
	# Apply UI layout now that ColorRects used for lighting shaders exist and are registered
	resize_handler.apply_immediate()

func _process(delta: float) -> void:
	# Tick the player tween first so visual_pos is fresh before any draw calls
	player.tick(delta)

	# Keep player light shader in sync with the smooth visual position every frame
	# (previously this only updated on the player_moved signal, which caused snapping)
	var player_position = renderer.player_screen_pos(tile_render_node, player)
	RenderingServer.global_shader_parameter_set("player_screen_pos", player_position)

	lighting.tick(delta)
	tile_render_node.redraw()
	entity_render_node.redraw()
	ui_render_node.redraw()

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
		torch_system.draw_torches_in_room(GlobalData.grid_size_cols, GlobalData.grid_size_rows, num_of_torches)
