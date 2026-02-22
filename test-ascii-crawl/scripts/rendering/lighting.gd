# LightingSystem currently handles the shaders used 
# - shaders used for lights on players and torches, currently.  
class_name LightingSystem

const PLAYER_SHADER_PATH = "res://shaders/player_light.gdshader"
const TORCH_SHADER_PATH  = "res://shaders/torch_light.gdshader"
const GLYPHS_PATH        = "res://data/glyphs.tres"

# Player light defaults, which are
const PLAYER_DEFAULTS = {
	light_color  = Color(0.944, 0.958, 0.997, 1.0),
	light_radius = 500.0,
	ambient      = 0.05,
	falloff      = 2.0,
}

const TORCH_DEFAULTS = {
	light_radius = 250.0,
	ambient = 0.00,
	falloff = 1.2,
}

var player_mat:   ShaderMaterial
var torch_mat:    ShaderMaterial
var player_rect:  ColorRect
var torch_rect:   ColorRect
var canvas:       Node2D
var player:       Player
var renderer:     Renderer
var torch_system: TorchSystem
var glyphs:       GameGlyphs
var elapsed:      float = 0.0

func _init(p_canvas: Node2D, p_player: Player,
		   p_player_rect: ColorRect, p_torch_rect: ColorRect,
		   p_renderer: Renderer, p_torch_system: TorchSystem) -> void:
	canvas       = p_canvas
	player       = p_player
	player_rect  = p_player_rect
	torch_rect   = p_torch_rect
	renderer     = p_renderer
	torch_system = p_torch_system
	glyphs       = load(GLYPHS_PATH)

	_setup_player_material()
	_setup_torch_material()
	_connect_signals()

func _setup_player_material() -> void:
	player_mat        = ShaderMaterial.new()
	player_mat.shader = load(PLAYER_SHADER_PATH)
	
	# Sets the values of the shader parameters, using the dictionary CONST
	for param in PLAYER_DEFAULTS:
		player_mat.set_shader_parameter(param, PLAYER_DEFAULTS[param])
	
	player_rect.material = player_mat

func _setup_torch_material() -> void:
	torch_mat        = ShaderMaterial.new()
	torch_mat.shader = load(TORCH_SHADER_PATH)
	
	# Sets the values of the shader parameters, using the dictionary CONST
	for param in TORCH_DEFAULTS:
		torch_mat.set_shader_parameter(param, TORCH_DEFAULTS[param])
	
	torch_rect.material = torch_mat

# The 'player_moved' signal is emitted by the player.try_move function,
# which is called when input is detected (in main.gd).  This signal is connected 
# to the _update_player_light function, which updates the 'player_screen_pos' shader 
# global variable, which causes the shader/light to move with the player.  
#
# The 'torches_updated' signal is emitted by the torch_system when adding new torches.
func _connect_signals() -> void:
	SignalBus.player_moved.connect(_update_player_light)
	SignalBus.torches_updated.connect(_update_torch_lights)

# Updates the 'player_screen_pos' shader global variable, which causes the shader/light 
# to move with the player. (The shader directly uses/connects to that global variable )
func _update_player_light(_col: int, _row: int) -> void:
	#var pos = renderer.player_screen_pos(canvas, player)
	var pos = renderer.tile_to_screen(canvas, _col, _row)
	RenderingServer.global_shader_parameter_set("player_screen_pos", pos)

# Called by tick (which is called from main on the _process function every frame).
# Also called when the torches_updated signal is emitted.
# Updates the torches animation variables & sets those in the shader.
func _update_torch_lights(_torches: Array) -> void:
	var torches   = _torches
	var count     = min(torches.size(), 20)
	var positions = []
	var radii     = []
	var colors    = []

	for i in count:
		var t = torches[i]
		positions.append(renderer.tile_to_screen(canvas, t.col, t.row))
		radii.append(torch_system.animated_radius(t, elapsed))
		colors.append(glyphs.torch.color)

	torch_mat.set_shader_parameter("torch_count",     count)
	torch_mat.set_shader_parameter("torch_positions", positions)
	torch_mat.set_shader_parameter("torch_radii",     radii)
	torch_mat.set_shader_parameter("torch_colors",    colors)

# Called by main to animate the shaders (currently, just torches)
func tick(delta: float) -> void:
	elapsed += delta
	_update_torch_lights(torch_system.torches)
