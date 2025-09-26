extends PlayerState
class_name PlayerFalling

func enter(previous_state_path: String, data := {}) -> void:
	pass
	#enter falling animation here

func physics_update(_delta: float) -> void:
	player.velocity.y -= player.gravity * _delta
	
	var input_dir : Vector2 = Input.get_vector("left", "right", "up", "down").normalized()
	if input_dir:
		player.velocity.x = input_dir.x * player.speed
		player.velocity.z = input_dir.y * player.speed
	player.move_and_slide()
	
	if player.is_on_floor():
		if input_dir:
			finished.emit(RUNNING)
		else:
			finished.emit(IDLE)
