extends PlayerState
class_name PlayerRunning

func enter(previous_state_path: String, data := {}) -> void:
	#play running animation here
	pass

func physics_update(delta: float) -> void:
	var input_dir : Vector2
	
	if player.player_index == 0:
		input_dir = Input.get_vector("move_left", "move_right", "move_up", "move_down").normalized()
	elif player.player_index == 1:
		input_dir = Input.get_vector("move_left_p2", "move_right_p2", "move_up_p2", "move_down_p2").normalized()
	
	if input_dir:
		player.velocity.x = input_dir.x * player.speed
		player.velocity.z = input_dir.y * player.speed
	else:
		finished.emit(IDLE)
	
	if player.player_index == 0:
		if Input.is_action_just_pressed("jump"):
			finished.emit(DASHING)
			
	elif player.player_index == 1:
		if Input.is_action_just_pressed("jump_p2"):
			finished.emit(DASHING)
