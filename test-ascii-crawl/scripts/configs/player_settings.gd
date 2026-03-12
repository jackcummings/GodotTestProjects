# This is used for the player settings - currently just color, but probably
# expanded to have other settings at some point.  This is hooked to the
# player_settings.tres resource.
class_name PlayerSettings
extends Resource

@export_group("Player Light", "pl")
@export var pl_color:   Color = Color(0.944, 0.958, 0.997, 1.0):
	set(v): pl_color = v; SignalBus.player_light_shader_changed.emit()
@export var pl_radius:  float = 500.0:
	set(v): pl_radius = v; SignalBus.player_light_shader_changed.emit()
@export var pl_ambient: float = 0.05:
	set(v): pl_ambient = v; SignalBus.player_light_shader_changed.emit()
@export var pl_falloff: float = 2.0:
	set(v): pl_falloff = v; SignalBus.player_light_shader_changed.emit()
