# This is used for the torch settings - color & lighting animation settings.
# This is hooked to the torch_settings.tres resource.
class_name TorchSettings
extends Resource

@export_group("Torch Light", "tl")
@export var tl_color:		Color = Color(0.88, 1.0, 0.765, 1.0):
	set(v): tl_color = v;	SignalBus.torches_shader_changed.emit()
@export var tl_radius:		float = 200.0:
	set(v): tl_radius = v; SignalBus.torches_shader_changed.emit()
@export var tl_ambient:		float = 0.00:
	set(v): tl_ambient = v; SignalBus.torches_shader_changed.emit()
@export var tl_falloff:		float = 1.2:
	set(v): tl_falloff = v; SignalBus.torches_shader_changed.emit()
@export var tl_color_mix:	float = 0.25:
	set(v): tl_color_mix = v; SignalBus.torches_shader_changed.emit()
@export_subgroup("Animation", "tl")
@export var tl_flicker:		float = 12.0:
	set(v): tl_flicker = v; SignalBus.torches_shader_changed.emit()
@export var tl_speed:		float = 5.6:
	set(v): tl_speed = v;	SignalBus.torches_shader_changed.emit()
