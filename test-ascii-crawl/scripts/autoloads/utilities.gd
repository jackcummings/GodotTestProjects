extends Node

func grid_to_pixel(c: int, r: int) -> Vector2:
	return Vector2(c * GlobalData.tile_width, r * GlobalData.tile_height)

func grid_center_to_pixel(c: int, r: int) -> Vector2:
	return grid_to_pixel(c, r) + (Vector2(GlobalData.tile_width, GlobalData.tile_height) * 0.5)

func ease_out_cubic(t: float) -> float:
	return 1.0 - pow(1.0 - t, 3.0)

# Function to get the center of tile in screen/pixel space, needed for shaders. 
# (Transform stuff is to accurately map position in local space to screen (pixel) space,
# based on 
func tile_to_screen(canvas: Node2D, col: int, row: int) -> Vector2:
	var local_center = grid_to_pixel(col, row) + \
					   Vector2(GlobalData.tile_width, GlobalData.tile_height) \
					   * 0.5
	return canvas.get_viewport().get_canvas_transform() \
		 * canvas.get_global_transform() \
		 * local_center
