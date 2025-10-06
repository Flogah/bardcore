extends State
class_name CombatIdle

func update(_delta: float) -> void:
	if owner.player_index == 0:
		if Input.is_action_pressed("shoot"):
			finished.emit("WeakAttack")
	
	elif owner.player_index == 1:
		if Input.is_action_pressed("shoot_p2"):
			finished.emit("WeakAttack")
