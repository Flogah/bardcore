extends State
class_name CombatIdle

func update(_delta: float) -> void:
	if owner.input.is_action_pressed("shoot"):
		finished.emit("WeakAttack")
