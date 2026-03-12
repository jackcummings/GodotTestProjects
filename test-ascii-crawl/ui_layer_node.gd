# Draws the UI sidebar. Repositioned and resized dynamically by ResizeHandler.
# Because stretch mode is disabled, this node renders in raw window pixels —
# position and size are set directly in screen space.
extends Node2D

var panel_settings:	UISettings
var renderer_ui:	RendererUI
var panels:			Array = []

func setup(p_renderer_ui: RendererUI, p_panel_settings: UISettings, p_panels: Array) -> void:
	panel_settings = p_panel_settings
	renderer_ui = p_renderer_ui
	panels   = p_panels

# Called by ResizeHandler on every resize
func on_resize(_w: float, _h: float) -> void:
	# Reposition is handled by ResizeHandler setting our position directly.
	# We don't cache anything — _draw() reads live window size every frame.
	queue_redraw()

func redraw() -> void:
	queue_redraw()

func _draw() -> void:
	# Read the true current window size right now, at draw time.
	# This is always correct regardless of when resize signals fired.
	var win				= get_viewport().get_visible_rect().size # Get current window size
	var sidebar_w		= round(win.x * panel_settings.sb_ratio) # calculate sidebar width through ratio
	var sidebar_h		= win.y # Sidebar takes up full y height, no ratio
	var scale_ratio_w	= sidebar_w / GlobalData.BASE_SIDEBAR_W
	# var scale_ratio_h = sidebar_h / GlobalData.BASE_WINDOW_H
	
	draw_rect(Rect2(0, 0, sidebar_w, sidebar_h), panel_settings.sb_bg_color)
	draw_line(Vector2(0, 0), Vector2(0, sidebar_h), panel_settings.sb_border_color, 1.0)
	renderer_ui.draw_panels(self, panels, scale_ratio_w)
	
	# Can also use the height, but tries to resize the font size when adjusting the 
	# height, which is usually unnecessary unless the window is made very short
	# _renderer_ui.draw_panels(self, _panels, minf(scale_ratio_w, scale_ratio_h))
