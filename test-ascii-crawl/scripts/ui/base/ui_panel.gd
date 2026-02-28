# UIPanel is the base class for all UI panels.
# Subclass it to create self-contained panels that own their layout,
# content, and signal connections.
#
# Subclass pattern:
#   class_name StatsPanel
#   extends UIPanel
#
#   func _init(player: Player) -> void:
#       super(col, row, width, [...rows...])
#       with_title("Stats")
#       # store refs, connect signals, etc.
class_name UIPanel
extends RefCounted

var col:   int
var row:   int
var width: int
var rows:  Array

var border_color: Color = Color(0.5, 0.5, 0.5)
var text_color:   Color = Color(0.85, 0.85, 0.85)
var sep_color:    Color = Color(0.35, 0.35, 0.35)
var title:        String = ""
var title_color:  Color = Color(1.0, 0.85, 0.4)

func _init(p_col: int, p_row: int, p_width: int, p_rows: Array) -> void:
	col   = p_col
	row   = p_row
	width = p_width
	rows  = p_rows

# Override in subclasses to wire up signals.
# Called by main after all game objects exist and signals are ready.
func connect_signals() -> void:
	pass

func with_title(p_title: String) -> UIPanel:
	title = p_title
	return self

func with_colors(p_border: Color, p_text: Color, p_sep: Color) -> UIPanel:
	border_color = p_border
	text_color   = p_text
	sep_color    = p_sep
	return self

func total_height() -> int:
	return rows.size() + 2

func total_width() -> int:
	return width + 2
