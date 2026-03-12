# ResizeHandler manages the game/sidebar split on window resize.
# The game renders into a SubViewport whose size is always (window_w * (1-<sidebar ratio>)
# with a height fixed to the window height. The camera inside it therefore only ever sees 
# that portion, so scrolling works correctly regardless of window size.
class_name ResizeHandler
extends Node

var _main_node:				 	Node = null
var _ui_layer_node:			 	Node2D = null
var _game_viewport:			 	SubViewport = null
var _game_viewport_container:	SubViewportContainer = null
var _sidebar_settings:		 	UISettings = null

func _init(p_main_node: Node, p_ui_layer_node: Node2D, p_game_viewport: SubViewport, 
		   p_game_viewport_container: SubViewportContainer, p_sidebar_settings: UISettings) -> void:
	_main_node = p_main_node
	_ui_layer_node = p_ui_layer_node
	_game_viewport = p_game_viewport
	_game_viewport_container = p_game_viewport_container
	_sidebar_settings = p_sidebar_settings

	_connect_signals()

# Signals
# - size_changed - Fired by the main Godot process when the window is resized
# - sidebar_settings_changed - Emitted by the ui_settings.gd Resource object when
#   the setter gets ran on sidebar ratio.  Only this setting needs a signal as the sidebar
#   ratio actually affects this resize_handler.gd file.  Positioning & resizing of the sidebar
#   from this file normally only happens when a resize event is caught, so forcing it to update
#   on a setting change is needed.
#
#   Also, the panel colors don't emit any signals on change as the panels themselves are redrawn
#   every frame, so those will automatically change.  Only the sidebar resize stuff is the special
#   case.
func _connect_signals() -> void:
	_main_node.get_tree().root.size_changed.connect(_on_window_resized)
	SignalBus.sidebar_settings_changed.connect(_on_window_resized)

func _on_window_resized() -> void:
	call_deferred("_apply_layout")

# Call once from main.gd after _init_lighting() so the first frame is correct
func apply_immediate() -> void:
	_apply_layout()

func _apply_layout() -> void:
	var win       = _main_node.get_tree().root.get_visible_rect().size
	var sidebar_w = round(win.x * _sidebar_settings.sb_ratio)
	var game_w    = win.x - sidebar_w

	# Resize the SubViewportContainer and SubViewport together.
	# The container controls how much screen space the game takes up;
	# the viewport controls the resolution the game renders at (same value
	# with stretch=true on the container, so no scaling occurs — more tiles
	# are just revealed as the window grows).
	if _game_viewport_container:
		_game_viewport_container.size = Vector2(game_w, win.y)
	if _game_viewport:
		_game_viewport.size = Vector2i(int(game_w), int(win.y))

	# Reposition and resize the sidebar.  Not sure if this validation of not null
	# and having the on_resize method is really necessary...
	if _ui_layer_node and _ui_layer_node.has_method("on_resize"):
		_ui_layer_node.position = Vector2(game_w, 0)
		_ui_layer_node.on_resize(sidebar_w, win.y)
