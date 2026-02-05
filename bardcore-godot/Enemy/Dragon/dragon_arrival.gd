extends Node3D

func small_shake():
	MapManager.current_map.shake(0.3, 3.0, 0.2)

func big_shake():
	MapManager.current_map.shake(0.6, 3.0, 0.5)
