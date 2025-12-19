extends State
class_name CombatIdle

func update(_delta: float) -> void:
	# disabled for now, as it doesn't add anything
	#if owner.input.is_action_pressed("shoot"):
		#finished.emit("WeakAttack")

	if owner.input.is_action_pressed("attack_line"):
		finished.emit("AttackLine")
	
	if owner.input.is_action_pressed("attack_circle"):
		finished.emit("AttackCircle")
	
	if owner.input.is_action_pressed("attack_cone"):
		finished.emit("AttackCone")
	
	if owner.input.is_action_pressed("attack_ring"):
		finished.emit("AttackRing")
	
	if owner.input.is_action_pressed("attack_wings"):
		finished.emit("AttackWings")
	
	if owner.input.is_action_pressed("attack_arrow"):
		finished.emit("AttackArrow")
