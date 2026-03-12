extends Node

# Player events
signal player_moved(col: int, row: int)
signal player_stats_changed()
signal player_light_shader_changed()

# Torch Events
signal torches_updated(torches: Array)
signal torches_shader_changed()

# UI: append a line to the message log
signal sidebar_settings_changed()
signal log_message(message: String)

# Other potential signals:
# 	signal enemy_died(enemy_id: int)
# 	signal item_picked_up(item_id: int)
# 	signal level_changed(level: int)
