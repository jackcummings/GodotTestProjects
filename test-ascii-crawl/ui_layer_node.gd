# Draws the UI sidebar. Repositioned and resized dynamically by ResizeHandler.
# Because stretch mode is disabled, this node renders in raw window pixels —
# position and size are set directly in screen space.
extends Node2D

const SIDEBAR_BG     = Color(0.06, 0.06, 0.08)
const SIDEBAR_BORDER = Color(0.25, 0.25, 0.30)

var ascii_ui:   AsciiUI
var panels:     Array = []
var _sidebar_w: float = 448
var _sidebar_h: float = 720

# Font scale applied to AsciiUI so glyphs grow with the sidebar.
# At the base window size (1600x720) this is 1.0.
var _scale: float = 1.0

const BASE_WINDOW_H = 720.0
const BASE_SIDEBAR_W = 448.0

func setup(p_ascii_ui: AsciiUI, p_panels: Array) -> void:
	ascii_ui = p_ascii_ui
	panels   = p_panels

# Called by ResizeHandler on every resize
func on_resize(new_w: float, new_h: float) -> void:
	_sidebar_w = new_w
	_sidebar_h = new_h
	# Scale by whichever dimension is more constrained, so glyphs never
	# overflow the sidebar width regardless of window aspect ratio.
	var scale_by_h = new_h / BASE_WINDOW_H
	var scale_by_w = new_w / BASE_SIDEBAR_W
	_scale         = minf(scale_by_h, scale_by_w)
	ascii_ui.scale = _scale
	queue_redraw()

func redraw() -> void:
	queue_redraw()

func _draw() -> void:
	draw_rect(Rect2(0, 0, _sidebar_w, _sidebar_h), SIDEBAR_BG)
	draw_line(Vector2(0, 0), Vector2(0, _sidebar_h), SIDEBAR_BORDER, 1.0)
	ascii_ui.draw_panels(self, panels)
