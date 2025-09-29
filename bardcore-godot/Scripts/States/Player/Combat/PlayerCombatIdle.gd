extends PlayerState
class_name PlayerCombatIdle

func update(_delta: float) -> void:
	if Input.is_action_pressed("shoot"):
		finished.emit("WeakAttack")
