# This script is attached to the Node2D 'TileLayerNode'.  This Node2D is
# used to draw the tilegrid (floors, walls) on the Node2D canvas. You can 
# see this where it passes 'self' to the renderer object for drawing.
extends Node2D

var renderer:  Renderer
var tile_grid:  TileGrid

func setup(p_renderer: Renderer, p_tile_grid: TileGrid) -> void:
	renderer = p_renderer
	tile_grid = p_tile_grid

func redraw() -> void:
	queue_redraw()

func _draw() -> void:
	renderer.draw_tiles(self, tile_grid)
