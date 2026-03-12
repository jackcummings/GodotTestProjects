# A scrolling message log panel. Keeps a rolling history of the last
# MAX_LINES messages and displays the most recent ones.  This probably
# would've been far less painful if I used the in-built text node somehow.
#
# Usage in main.gd:
#   var log_panel = MessageLogPanel.new(1, 10, 36, 5)
#
# To post a message anywhere in your code:
#   SignalBus.log_message.emit("You pick up a sword.")
class_name MessageLogPanel
extends UIPanel

const MAX_HISTORY = 64   # How many messages to remember in total.  TODO: Make configurable?
const ROW_NONE    = ""   # Empty line placeholder

var _history:		Array  = []   # Queue (or 'Ring buffer') of past messages
var _visible_lines:	int           # How many lines the panel shows at once.  TODO: Make configurable?

func _init(p_panel_settings: UISettings, p_col: int, p_row: int, p_width: int, p_visible_lines: int) -> void:
	_visible_lines = p_visible_lines
	_panel_settings = p_panel_settings # panel_settings is on the base UIPanel class
	
	# Initialise rows to empty strings so the panel has a fixed height
	var initial_rows = []
	for i in _visible_lines:
		initial_rows.append(ROW_NONE)

	super(p_col, p_row, p_width, initial_rows)
	with_title(" Log ")
	with_colors(_panel_settings.mp_title_color, _panel_settings.mp_text_color, 
				_panel_settings.mp_border_color, _panel_settings.mp_sep_color)
				
	_connect_signals()

# Log Messages use the signal bus to receive log messages.
func _connect_signals() -> void:
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

	# Take the last visible_lines entries
	var start = maxi(0, wrapped.size() - _visible_lines)
	for i in _visible_lines:
		var idx = start + i
		data_rows[i] = wrapped[idx] if idx < wrapped.size() else ROW_NONE # fancy inline if!

# Naive word-wrap: splits on spaces, fills lines up to max_width chars.  AI generated
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
