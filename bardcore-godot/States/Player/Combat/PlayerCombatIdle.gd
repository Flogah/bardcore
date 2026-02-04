extends State
class_name CombatIdle

@export var attack_1:State
@export var attack_2:State
@export var attack_3:State

func update(_delta: float) -> void:
	if !owner.get_parent().can_attack:
		return
	
	if owner.input.is_action_pressed("attack_1"):
		finished.emit(attack_1.name)
	
	elif owner.input.is_action_pressed("attack_2"):
		finished.emit(attack_2.name)
	
	elif owner.input.is_action_pressed("attack_3"):
		finished.emit(attack_3.name)
