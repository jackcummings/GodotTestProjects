# AsciiUI handles drawing UIPanel objects onto a Node2D canvas.
# It converts panel definitions into draw calls that match
# the existing Renderer style (same tile grid, same font, same sizing).
#
# Box-drawing characters used:
#   ┌ ┐ └ ┘  — corners
#   │          — vertical border
#   ─          — horizontal border / separator
#   ├ ┤        — separator row joints
class_name RendererUI
extends RefCounted

# Box drawing chars
const CH_TL: 	String = "┌"
const CH_TR: 	String = "┐"
const CH_BL: 	String = "└"
const CH_BR:	String = "┘"
const CH_H:		String = "─"
const CH_V:		String = "│"
const CH_ML:	String = "├"
const CH_MR:	String = "┤"

# Should be same tile widths used in the regular tile grid (these get passed in)
var _tile_width:	int
var _tile_height:	int
var _font_size:		int
var _font:			Font
var _origin:		Vector2   # A pixel offset applied to all draw calls, if needed
var _scale:			float = 1.0 

func _init(p_tile_width: int, p_tile_height: int, p_font_size: int, p_origin: Vector2 = Vector2.ZERO) -> void:
	_tile_width = p_tile_width
	_tile_height = p_tile_height
	_font_size = p_font_size
	_font   = ThemeDB.fallback_font
	_origin = p_origin

# Draw all panels in the given array onto the canvas.
func draw_panels(canvas: Node2D, panels: Array, size_scale: float = 1.0) -> void:
	_scale = size_scale
	for panel in panels:
		_draw_panel(canvas, panel)

func _draw_panel(canvas: Node2D, panel: UIPanel) -> void:
	# --------------------
	# ---- Top border ----
	# --------------------
	# Draw top left corner character
	_draw_char(canvas, panel.col, panel.row, CH_TL, panel.border_color)
	if panel.title != "":
		# Add space to either side of title
		var title_str: String = " " + panel.title + " "
		# Padding characters '-' fill up what is left of the top border
		var pad_total = panel.width - title_str.length()
		# Half of padding on left, half on right, so title is centered
		var pad_l: int	= pad_total / 2
		var pad_r: int	= pad_total - pad_l
		
		# Draw left side padding characters
		for i in pad_l:
			_draw_char(canvas, panel.col + 1 + i, panel.row, CH_H, panel.border_color)
		# Draw title
		for i in title_str.length():
			_draw_char(canvas, panel.col + 1 + pad_l + i, panel.row, title_str[i], panel.title_color)
		# Draw right side padding characters
		for i in pad_r:
			_draw_char(canvas, panel.col + 1 + pad_l + title_str.length() + i, panel.row, CH_H, panel.border_color)
	# If no title, just border '-' characters
	else:
		for i in panel.width:
			_draw_char(canvas, panel.col + 1 + i, panel.row, CH_H, panel.border_color)
	# Draw top right corner
	_draw_char(canvas, panel.col + panel.width + 1, panel.row, CH_TR, panel.border_color)

	# ----------------------
	# ---- Content rows ----
	# ----------------------
	for current_row in panel.data_rows.size():
		# Variant type used for content_row as rows can be null (for a seperator line)
		# and String isn't nullable
		var content_row: Variant = panel.data_rows[current_row] 
		var draw_row: int = panel.row + 1 + current_row

		# Seperator line drawn if row value is null
		if content_row == null:
			_draw_char(canvas, panel.col, draw_row, CH_ML, panel.border_color)
			for i in panel.width:
				_draw_char(canvas, panel.col + 1 + i, draw_row, CH_H, panel.sep_color)
			_draw_char(canvas, panel.col + panel.width + 1, draw_row, CH_MR, panel.border_color)
		# Row must be a string if not null
		else:
			var text = str(content_row)
			
			# If still too long, cut off the excess.  This means no super long words for now
			if text.length() > panel.width:
				text = text.substr(0, panel.width) 

			# Draw left side border
			_draw_char(canvas, panel.col, draw_row, CH_V, panel.border_color)
			# Draw content
			for i in text.length():
				_draw_char(canvas, panel.col + 1 + i, draw_row, text[i], panel.text_color)
			# Fill up leftover space with blanks
			for i in range(text.length(), panel.width):
				_draw_char(canvas, panel.col + 1 + i, draw_row, " ", panel.text_color)
			# Draw right side border
			_draw_char(canvas, panel.col + panel.width + 1, draw_row, CH_V, panel.border_color)

	# -----------------------
	# ---- Bottom border ----
	# -----------------------
	var bottom_row = panel.row + panel.data_rows.size() + 1
	
	# Draw bottom left corner character
	_draw_char(canvas, panel.col, bottom_row, CH_BL, panel.border_color)
	# Draw line characters for bottom border
	for i in panel.width:
		_draw_char(canvas, panel.col + 1 + i, bottom_row, CH_H, panel.border_color)
	# Draw bottom right corner character
	_draw_char(canvas, panel.col + panel.width + 1, bottom_row, CH_BR, panel.border_color)

func _draw_char(canvas: Node2D, col: int, row: int, ch: String, color: Color) -> void:
	# Scale the tile size & font size, based on current scale
	var adjusted_tile_width: float	= _tile_width * _scale
	var adjusted_tile_height: float	= _tile_height * _scale
	var adjusted_font_size: float	= int(_font_size * _scale)
	
	var pos = _origin + Vector2(col * adjusted_tile_width, row * adjusted_tile_height)
	canvas.draw_rect(Rect2(pos, Vector2(adjusted_tile_width, adjusted_tile_height)), Color.BLACK)
	# Position is adjusted to try and center it a bit better between the borders.  A lot of trial 
	# and error... probably is a better, more 'scientific' way to do this
	canvas.draw_string(_font, pos + Vector2(4 * _scale, adjusted_tile_height - 2 * _scale),
					   ch, HORIZONTAL_ALIGNMENT_LEFT, -1, adjusted_font_size, color)
