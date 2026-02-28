extends Node

# Player events
signal player_moved(col: int, row: int)

# Torch Events
signal torches_updated(torches: Array)

# UI: player stat changes (emit whenever hp/mp/gold etc. change)
signal player_stats_changed()

# UI: floor/level changed
signal floor_changed(floor_num: int)

# UI: append a line to the message log
signal log_message(message: String)

# Other potential signals:
# 	signal enemy_died(enemy_id: int)
# 	signal item_picked_up(item_id: int)
# 	signal level_changed(level: int)
