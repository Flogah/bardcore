extends PlayerState
class_name PlayerMoveIdle

func enter(previous_state_path: String, data := {}) -> void:
	player.velocity = Vector3.ZERO
	# play idle animation

func physics_update(_delta: float) -> void:
	#player.velocity.y += player.gravity * _delta
	player.velocity.x = move_toward(player.velocity.x, 0, player.speed)
	player.velocity.z = move_toward(player.velocity.z, 0, player.speed)
	
	if player.player_index == 0:
		var input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		if input_dir:
			finished.emit(RUNNING)
	
	if player.player_index == 1:
		var input_dir = Input.get_vector("move_left_p2", "move_right_p2", "move_up_p2", "move_down_p2")
		if input_dir:
			finished.emit(RUNNING)
