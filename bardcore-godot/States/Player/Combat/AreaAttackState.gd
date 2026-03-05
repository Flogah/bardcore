extends State
class_name AreaAttackState

@export var attackArea: PackedScene
@export var attack_spawn: Node3D

var attackArea_instance

func enter(previous_state_path: String, data := {}) -> void:
	attackArea_instance = attackArea.instantiate()
	# end attack is only triggered once the sound effect is done, to stop too many overlaying sounds
	attackArea_instance.attack_sound_finished.connect(end_attack)
	# bard data is set first because attack areas are not connected to the player
	attackArea_instance.set_bard_data(owner.player_num)
	attack_spawn.add_child(attackArea_instance)

func end_attack():
	# attack areas are cleaned up here before returning to idle
	attackArea_instance.queue_free()
	finished.emit("Idle")
