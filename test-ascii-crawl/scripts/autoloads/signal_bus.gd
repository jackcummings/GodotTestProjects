extends Node

# Player events
signal player_moved(col: int, row: int)

# Torch Events
signal torches_updated(torches: Array)

# Other potential signals:
# 	signal enemy_died(enemy_id: int)
# 	signal item_picked_up(item_id: int)
# 	signal level_changed(level: int)
