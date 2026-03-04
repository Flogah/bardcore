extends State
class_name AttackCone

@export var attackArea: PackedScene = preload("uid://d0o1tl8lwamf")

@export var attack_spawn: Node3D

var attackArea_instance

func enter(previous_state_path: String, data := {}) -> void:
	attackArea_instance = attackArea.instantiate()
	attackArea_instance.attack_sound_finished.connect(end_attack)
	attackArea_instance.set_bard_data(owner.player_num)
	attack_spawn.add_child(attackArea_instance)

func end_attack():
	attackArea_instance.queue_free()
	finished.emit("Idle")
