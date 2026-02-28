# AsciiUI handles drawing UIPanel objects onto a Node2D canvas.
# It converts panel definitions into glyph draw calls that match
# the existing Renderer style (same tile grid, same font, same sizing).
#
# Box-drawing characters used:
#   ┌ ┐ └ ┘  — corners
#   │          — vertical border
#   ─          — horizontal border / separator
#   ├ ┤        — separator row joints
class_name AsciiUI

var BASE_TILE_W    = GlobalData.tile_width
var BASE_TILE_H    = GlobalData.tile_height
var BASE_FONT_SIZE = GlobalData.font_size

# Box drawing chars
const CH_TL  = "┌"
const CH_TR  = "┐"
const CH_BL  = "└"
const CH_BR  = "┘"
const CH_H   = "─"
const CH_V   = "│"
const CH_ML  = "├"
const CH_MR  = "┤"

var font: Font
var origin: Vector2   # pixel offset applied to all draw calls
var scale:  float   = 1.0   # set by UILayerNode.on_resize()

func _init(p_origin: Vector2 = Vector2.ZERO) -> void:
	font   = ThemeDB.fallback_font
	origin = p_origin

# Draw all panels in the given array onto the canvas.
func draw_panels(canvas: Node2D, panels: Array) -> void:
	for panel in panels:
		_draw_panel(canvas, panel)

func _draw_panel(canvas: Node2D, panel: UIPanel) -> void:
	var c = panel.col
	var r = panel.row
	var w = panel.width

	# Top border
	_draw_char(canvas, c, r, CH_TL, panel.border_color)
	if panel.title != "":
		var title_str = " " + panel.title + " "
		var pad_total = w - title_str.length()
		var pad_l     = pad_total / 2
		var pad_r     = pad_total - pad_l
		for i in pad_l:
			_draw_char(canvas, c + 1 + i, r, CH_H, panel.border_color)
		for i in title_str.length():
			_draw_char(canvas, c + 1 + pad_l + i, r, title_str[i], panel.title_color)
		for i in pad_r:
			_draw_char(canvas, c + 1 + pad_l + title_str.length() + i, r, CH_H, panel.border_color)
	else:
		for i in w:
			_draw_char(canvas, c + 1 + i, r, CH_H, panel.border_color)
	_draw_char(canvas, c + w + 1, r, CH_TR, panel.border_color)

	# Content rows
	for row_idx in panel.rows.size():
		var content_row = panel.rows[row_idx]
		var draw_row    = r + 1 + row_idx

		if content_row == null:
			_draw_char(canvas, c,         draw_row, CH_ML, panel.border_color)
			for i in w:
				_draw_char(canvas, c + 1 + i, draw_row, CH_H, panel.sep_color)
			_draw_char(canvas, c + w + 1, draw_row, CH_MR, panel.border_color)
		else:
			var text = str(content_row)
			if text.length() > w:
				text = text.substr(0, w)
			_draw_char(canvas, c, draw_row, CH_V, panel.border_color)
			for i in text.length():
				_draw_char(canvas, c + 1 + i, draw_row, text[i], panel.text_color)
			for i in range(text.length(), w):
				_draw_char(canvas, c + 1 + i, draw_row, " ", panel.text_color)
			_draw_char(canvas, c + w + 1, draw_row, CH_V, panel.border_color)

	# Bottom border
	var bottom_row = r + panel.rows.size() + 1
	_draw_char(canvas, c, bottom_row, CH_BL, panel.border_color)
	for i in w:
		_draw_char(canvas, c + 1 + i, bottom_row, CH_H, panel.border_color)
	_draw_char(canvas, c + w + 1, bottom_row, CH_BR, panel.border_color)

func _draw_char(canvas: Node2D, col: int, row: int, ch: String, color: Color) -> void:
	var tw   = BASE_TILE_W * scale
	var th   = BASE_TILE_H * scale
	var fs   = int(BASE_FONT_SIZE * scale)
	var pos  = origin + Vector2(col * tw, row * th)
	canvas.draw_rect(Rect2(pos, Vector2(tw, th)), Color.BLACK)
	canvas.draw_string(font, pos + Vector2(2 * scale, th - 2 * scale),
					   ch, HORIZONTAL_ALIGNMENT_LEFT, -1, fs, color)
