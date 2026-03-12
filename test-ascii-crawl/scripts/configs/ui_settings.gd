# UI Panel Colors
class_name UISettings
extends Resource

@export_group("Side Bar", "sb")
@export_subgroup("Size", "sb")
@export var sb_ratio:   float = 0.28:
	set(v): sb_ratio = v; SignalBus.sidebar_settings_changed.emit()

@export_subgroup("Colors", "sb")
@export var sb_bg_color:		Color = Color(0.059, 0.059, 0.078, 1.0)
@export var sb_border_color:	Color = Color(0.251, 0.251, 0.298, 1.0)

@export_group("Stats Panel", "sp")
@export_subgroup("Colors", "sp")
@export var sp_title_color:		Color = Color(0.698, 0.851, 1.0, 1.0)
@export var sp_border_color:	Color = Color(0.451, 0.451, 0.549, 1.0)
@export var sp_text_color:		Color = Color(0.851, 0.851, 0.851, 1.0)
@export var sp_sep_color:		Color = Color(0.349, 0.349, 0.349, 1.0)

@export_group("Message Panel", "mp")
@export_subgroup("Colors", "mp")
@export var mp_title_color:		Color = Color(0.6, 0.898, 0.6, 1.0)
@export var mp_border_color: 	Color = Color(0.4, 0.498, 0.4, 1.0)
@export var mp_text_color:		Color = Color(0.749, 0.851, 0.749, 1.0)
@export var mp_sep_color:		Color = Color(0.349, 0.349, 0.349, 1.0)
