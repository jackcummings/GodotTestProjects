extends Node

# Current Tile attributes - globals so these can change depending on 
# the needs of the grid that is loaded
# TODO: Make configurable?
var tile_width: int = 16
var tile_height: int	= 16
var font_size: int	= tile_height

var grid_size_cols: int = 80
var grid_size_rows: int = 45

# UI
const BASE_SIDEBAR_W = 448.0 # Original, designed sidebar width.  Used as basis for resizing
const BASE_WINDOW_H  = 720.0 # Original, designed sidebar height.  Used as basis for resizing

# Paths to the resource & shader files
const GLYPHS_PATH: String 			= "res://data/game_glyphs.tres"
const UI_SETTINGS_PATH: String 		= "res://data/ui_settings.tres"
const PLAYER_SETTINGS_PATH: String 	= "res://data/player_settings.tres"
const TORCH_SETTINGS_PATH: String 	= "res://data/torch_settings.tres"
const PLAYER_SHADER_PATH: String	= "res://shaders/player_light.gdshader"
const TORCH_SHADER_PATH: String		= "res://shaders/torch_light.gdshader"
