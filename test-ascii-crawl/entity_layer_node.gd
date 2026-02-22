# This script is attached to the Node2D 'EntityLayerNode'.  This Node2D is
# used to draw the entities (player and torches, currently) on the Node2D canvas.
# You can see this where it passes 'self' to the renderer object for drawing.
# This allows us to layer the entities draws on top of the grid.
extends Node2D

var renderer:     Renderer
var player:       Player
var torch_system: TorchSystem

func setup(p_renderer: Renderer, p_player: Player, p_torch_system: TorchSystem) -> void:
	renderer     = p_renderer
	player       = p_player
	torch_system = p_torch_system

func redraw() -> void:
	queue_redraw()

func _draw() -> void:
	renderer.draw_entities(self, player, torch_system)
