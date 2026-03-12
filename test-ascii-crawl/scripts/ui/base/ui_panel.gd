# UIPanel - base class for all UI panels.  Panels inherit from UIPanel to create 
# self-contained panels that have unique layouts, logic, and signal connections.
#
# Basic example
#   class_name StatsPanel
#   extends UIPanel
#
#   func _init(player: Player) -> void:
#       super(col, row, width, [...data_rows...])
#       with_title("Stats")
#       # store refs, connect signals, etc.
class_name UIPanel
extends RefCounted

# Public variables (used by renderer_ui for 'generically' drawing panels)
var col:			int
var row:			int
var width:			int

var border_color: Color = Color(0.5, 0.5, 0.5)
var text_color:   Color = Color(0.85, 0.85, 0.85)
var sep_color:    Color = Color(0.35, 0.35, 0.35)
var title_color:  Color = Color(1.0, 0.85, 0.4)
var title:        String = ""
var data_rows:	  Array

# Private Variables
var _panel_settings: UISettings = null

func _init(p_col: int, p_row: int, p_width: int, p_data_rows: Array) -> void:
	col   = p_col
	row   = p_row
	width = p_width
	data_rows  = p_data_rows
	
func with_title(p_title: String) -> UIPanel:
	title = p_title
	return self

func with_colors(p_title: Color, p_text: Color, p_border: Color, p_sep: Color) -> UIPanel:
	border_color = p_border
	text_color   = p_text
	sep_color    = p_sep
	text_color	 = p_text
	
	return self

# UI Panels all have 1 width borders
func total_height() -> int:
	return data_rows.size() + 2

# UI Panels all have 1 width borders
func total_width() -> int:
	return width + 2
