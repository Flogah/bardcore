extends PlayerState
class_name PlayerRunning

func enter(previous_state_path: String, data := {}) -> void:
	#play running animation here
	pass

func physics_update(delta: float) -> void:
	var input_dir : Vector2 = Input.get_vector("left", "right", "up", "down").normalized()
	if input_dir:
		player.velocity.x = input_dir.x * player.speed
		player.velocity.z = input_dir.y * player.speed
	else:
		finished.emit(IDLE)
	
	if Input.is_action_just_pressed("jump"):
		finished.emit(DASHING)
