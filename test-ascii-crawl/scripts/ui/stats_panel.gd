# Displays player stats: HP, MP, floor, gold.
# Connects to SignalBus signals to catch any
#
# Usage in main.gd:
#   var stats_panel = StatsPanel.new(player, 1, 1)
class_name StatsPanel
extends UIPanel

# Row indices — named constants so updates are readable, not magic numbers
const ROW_HP	= 0
const ROW_MP	= 1
const ROW_SEP	= 2
const ROW_FLOOR	= 3
const ROW_GOLD	= 4

var _player: Player

func _init(p_player: Player, p_panel_settings: UISettings, p_col: int, p_row: int) -> void:
	_player = p_player
	_panel_settings = p_panel_settings # panel_settings is on the base UIPanel class
	
	# 
	super(p_col, p_row, 24, [
		_hp_text(),		# First line is HP
		_mp_text(),		# Then MP
		null,			# A null gives a separator
		_floor_text(),
		_gold_text(),
	])
	with_title(" Stats ")
	with_colors(_panel_settings.sp_title_color, _panel_settings.sp_text_color, 
				_panel_settings.sp_border_color, _panel_settings.sp_sep_color)
				
	_connect_signals()
	
func _connect_signals() -> void:
	SignalBus.player_stats_changed.connect(_on_stats_changed)

func _on_stats_changed() -> void:
	data_rows[ROW_HP] = _hp_text()
	data_rows[ROW_MP] = _mp_text()

# --------------------------
# --- Formatting helpers ---
# --------------------------
func _hp_text() -> String:
	return "HP : %s %d/%d" % [
		_bar(_player.hp, _player.max_hp, 8),
		_player.hp,
		_player.max_hp
	]

func _mp_text() -> String:
	return "MP : %s %d/%d" % [
		_bar(_player.mp, _player.max_mp, 8),
		_player.mp,
		_player.max_mp
	]

func _floor_text() -> String:
	return "Floor : 1"

func _gold_text() -> String:
	return "Gold  : 0"

# Renders a simple ASCII bar, e.g. "[████░░░░]" - Thanks Google AI search thing!
func _bar(current: int, maximum: int, bar_width: int) -> String:
	if maximum <= 0:
		return "[" + "░".repeat(bar_width) + "]"
	var filled = int(float(current) / float(maximum) * bar_width)
	filled = clampi(filled, 0, bar_width)
	return "[" + "█".repeat(filled) + "░".repeat(bar_width - filled) + "]"
