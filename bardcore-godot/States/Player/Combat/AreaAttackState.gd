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
	#attack_spawn.add_child(attackArea_instance)
	
	var p_node: Player = PlayerManager.player_nodes[owner.player_num]
	
	attackArea_instance.position = p_node.global_position
	attackArea_instance.rotation = p_node.rotation
	# we need to check first if we are in a valid scene or in the map of the map manager
	# basically, current scene = village, else is a random map
	var cur_scene = get_tree().current_scene
	if cur_scene:
		get_tree().current_scene.add_child(attackArea_instance)
	else:
		MapManager.current_map.add_child(attackArea_instance)

func end_attack():
	# attack areas are cleaned up here before returning to idle
	attackArea_instance.queue_free()
	finished.emit("Idle")
