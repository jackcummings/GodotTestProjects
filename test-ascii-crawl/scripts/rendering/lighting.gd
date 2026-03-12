# LightingSystem currently handles the shaders used 
# - shaders used for lights on players and torches, currently.  
class_name LightingSystem
extends RefCounted

var _player_shader_config_parameters = {
	light_color = Color(0.0, 0.0, 0.0, 1.0),
	light_radius = 0.0,
	ambient = 0.0,
	falloff = 0.0
}

var _torch_shader_config_parameters = {
	light_color = Color(0.0, 0.0, 0.0, 1.0),
	ambient = 0.0,
	falloff = 0.0,
	color_mix = 0.0
}

var _canvas:			Node2D
var _player:			Player
var _torch_system:		TorchSystem
var _player_rect:		ColorRect
var _torch_rect:		ColorRect
var _player_mat:		ShaderMaterial
var _torch_mat:			ShaderMaterial
var _glyphs:			GameGlyphs
var _player_settings:	PlayerSettings
var _torch_settings:	TorchSettings
var _elapsed:			float = 0.0

func _init(p_canvas: Node2D, p_player: Player, p_player_settings: PlayerSettings,
		   p_torch_settings: TorchSettings, p_player_rect: ColorRect, p_torch_rect: ColorRect,
		   p_torch_system: TorchSystem, p_glyphs: GameGlyphs) -> void:
	_canvas = p_canvas
	_player = p_player
	_player_settings = p_player_settings
	_torch_settings = p_torch_settings
	_player_rect = p_player_rect
	_torch_rect = p_torch_rect
	_torch_system = p_torch_system
	_glyphs = p_glyphs

	# Pass 'true' to the totalReload parameter so the shader material
	# gets creatd & loaded
	_update_player_shader(true)
	_update_torches_shader(true)
	
	_connect_signals()

func _update_player_shader(totalReload: bool = false) -> void:
	if totalReload:
		_player_mat = ShaderMaterial.new()
		_player_mat.shader = load(GlobalData.PLAYER_SHADER_PATH)
		_player_rect.material = _player_mat

	_player_shader_config_parameters["light_color"]		= _player_settings.pl_color
	_player_shader_config_parameters["light_radius"]	= _player_settings.pl_radius
	_player_shader_config_parameters["ambient"]			= _player_settings.pl_ambient
	_player_shader_config_parameters["falloff"]			= _player_settings.pl_falloff

	_updated_shader_settings(_player_mat, _player_shader_config_parameters)
	
func _update_torches_shader(totalReload: bool = false) -> void:
	if totalReload:
		_torch_mat = ShaderMaterial.new()
		_torch_mat.shader = load(GlobalData.TORCH_SHADER_PATH)
		_torch_rect.material = _torch_mat
	
	_torch_shader_config_parameters["light_color"]	= _torch_settings.tl_color
	_torch_shader_config_parameters["ambient"]		= _torch_settings.tl_ambient
	_torch_shader_config_parameters["falloff"]		= _torch_settings.tl_falloff
	_torch_shader_config_parameters["color_mix"]	= _torch_settings.tl_color_mix

	_updated_shader_settings(_torch_mat, _torch_shader_config_parameters)

# Helper function to set the shader parameters
func _updated_shader_settings(p_material: ShaderMaterial, p_settings: Dictionary) -> void:
	for param in p_settings:
		p_material.set_shader_parameter(param, p_settings[param])
		
# Signals
# - The 'player_moved' signal is emitted by the player.try_move function,
#   which is called when input is detected (in main.gd).  This signal is connected 
#   to the _update_player_light function, which updates the 'player_screen_pos' shader 
#   global variable, which causes the shader/light to move with the player.
#
# - The 'torches_updated' signal is emitted by the torch_system when adding new torches.
#
# - 'player_light_shader_changed' signal emitted when player settings are updated in game_lights.gd Resource 
#
# - 'torches_light_shader_changed' signal emitted when torches settings are updated in game_lights.gd Resource 
func _connect_signals() -> void:
	SignalBus.player_moved.connect(_update_player_light)
	SignalBus.torches_updated.connect(_update_torch_lights)
	
	SignalBus.player_light_shader_changed.connect(_update_player_shader)
	SignalBus.torches_shader_changed.connect(_update_torches_shader)
	
# Updates the 'player_screen_pos' shader global variable, which causes the shader/light 
# to move with the player. (The shader directly uses/connects to that global variable )
func _update_player_light(_col: int, _row: int) -> void:
	var pos = Utilities.tile_to_screen(_canvas, _col, _row)
	RenderingServer.global_shader_parameter_set("player_screen_pos", pos)

# Called by tick (which is called from main on the _process function every frame).
# Also called when the torches_updated signal is emitted (when adding new torches).
# Updates the torches animation variables & sets those in the shader.
func _update_torch_lights(_torches: Array) -> void:
	var torches = _torches
	var count = min(torches.size(), 50)
	var positions = []
	var radii = []

	for i in count:
		var t = torches[i]
		positions.append(Utilities.tile_to_screen(_canvas, t.col, t.row))
		radii.append(_animated_radius(t, _elapsed))

	_torch_mat.set_shader_parameter("torch_count",     count)
	_torch_mat.set_shader_parameter("torch_positions", positions)
	_torch_mat.set_shader_parameter("torch_radii",     radii)

# AI did this 'animation'... probably could be better.  Called during the  
# '_update_torch_lights' function (which is called by the 'tick' function) 
# to update the animated radius varible & then update the shader variables.
func _animated_radius(torch: Dictionary, elapsed: float) -> float:
	var noise = sin(elapsed * _torch_settings.tl_speed + torch.phase) * 0.6 \
			  + sin(elapsed * _torch_settings.tl_speed * 2.3 + torch.phase) * 0.3 \
			  + sin(elapsed * _torch_settings.tl_speed * 5.1 + torch.phase) * 0.1
	
	return _torch_settings.tl_radius + noise * _torch_settings.tl_flicker

# Called by main to animate the shaders (currently, just torches)
func tick(delta: float) -> void:
	_elapsed += delta
	_update_torch_lights(_torch_system.torches)
