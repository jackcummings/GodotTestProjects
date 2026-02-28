# A scrolling message log panel. Keeps a rolling history of the last
# MAX_LINES messages and displays the most recent ones.
#
# Usage in main.gd:
#   var log_panel = MessageLogPanel.new(1, 10, 36, 5)
#   log_panel.connect_signals()
#
# To post a message anywhere in your code:
#   SignalBus.log_message.emit("You pick up a sword.")
class_name MessageLogPanel
extends UIPanel

const MAX_HISTORY = 64   # how many messages to remember in total
const ROW_NONE    = ""   # empty line placeholder

var _history:       Array  = []   # ring buffer of past messages
var _visible_lines: int           # how many lines the panel shows at once

func _init(p_col: int, p_row: int, p_width: int, p_visible_lines: int) -> void:
	_visible_lines = p_visible_lines

	# Initialise rows to empty strings so the panel has a fixed height
	var initial_rows = []
	for i in _visible_lines:
		initial_rows.append(ROW_NONE)

	super(p_col, p_row, p_width, initial_rows)

	with_title(" Log ")
	border_color = Color(0.4, 0.5, 0.4)
	title_color  = Color(0.6, 0.9, 0.6)
	text_color   = Color(0.75, 0.85, 0.75)

func connect_signals() -> void:
	SignalBus.log_message.connect(_on_log_message)

func _on_log_message(message: String) -> void:
	_history.append(message)
	if _history.size() > MAX_HISTORY:
		_history.pop_front()
	_refresh_rows()

# Rebuild the visible rows from the tail of the history buffer.
# Word-wraps long messages to fit the panel width.
func _refresh_rows() -> void:
	var wrapped: Array = []
	for msg in _history:
		for line in _word_wrap(msg, width - 2):   # -2 for 1-char padding each side
			wrapped.append(line)

	# Take the last _visible_lines entries
	var start = maxi(0, wrapped.size() - _visible_lines)
	for i in _visible_lines:
		var idx = start + i
		rows[i] = wrapped[idx] if idx < wrapped.size() else ROW_NONE

# Naive word-wrap: splits on spaces, fills lines up to max_width chars.
func _word_wrap(text: String, max_width: int) -> Array:
	var lines   = []
	var words   = text.split(" ")
	var current = ""
	for word in words:
		if current == "":
			current = word
		elif current.length() + 1 + word.length() <= max_width:
			current += " " + word
		else:
			lines.append(current)
			current = word
	if current != "":
		lines.append(current)
	return lines if lines.size() > 0 else [""]
