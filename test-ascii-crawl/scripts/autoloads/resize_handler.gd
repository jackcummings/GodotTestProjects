# ResizeHandler is an autoload that manages the dynamic split between the
# game viewport and the UI sidebar when the window is resized.
#
# Project Settings required:
#   display/window/stretch/mode   = "disabled"
#   display/window/stretch/aspect = "ignore"
#   display/window/size/viewport_width  = 1600
#   display/window/size/viewport_height = 720
#   display/window/size/min_width  = 800
#   display/window/size/min_height = 400
#
# With stretch disabled, the viewport size equals the window size exactly.
# The camera shows more or fewer tiles as the window grows or shrinks.
# The sidebar is always SIDEBAR_RATIO of the window width.
extends Node

# The proportional split — 28% sidebar, 72% game area.
# Matches the original 448/1600 ratio.
const SIDEBAR_RATIO = 0.28

# Registered by main.gd after the scene is ready
var ui_layer_node:   Node2D    = null
var player_rect:     ColorRect = null
var torch_rect:      ColorRect = null

func _ready() -> void:
	get_tree().root.size_changed.connect(_on_window_resized)

func _on_window_resized() -> void:
	_apply_layout()

# Call once from main.gd after _init_lighting() so the first frame is correct
func apply_immediate() -> void:
	_apply_layout()

func _apply_layout() -> void:
	var win      = get_tree().root.get_visible_rect().size
	var sidebar_w = round(win.x * SIDEBAR_RATIO)
	var game_w    = win.x - sidebar_w

	# --- Reposition sidebar ---
	if ui_layer_node and ui_layer_node.has_method("on_resize"):
		ui_layer_node.position = Vector2(game_w, 0)
		ui_layer_node.on_resize(sidebar_w, win.y)

	# --- Resize light ColorRects to cover only the game area ---
	# These must NOT extend into the sidebar or the shaders dim the UI.
	if player_rect:
		player_rect.size = Vector2(game_w, win.y)
	if torch_rect:
		torch_rect.size  = Vector2(game_w, win.y)

# Returns the current game area width in pixels (useful for other systems)
func game_area_width() -> float:
	var win = get_tree().root.get_visible_rect().size
	return win.x - round(win.x * SIDEBAR_RATIO)
