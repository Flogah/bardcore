extends PlayerState
class_name PlayerRunning

func enter(previous_state_path: String, data := {}) -> void:
	#play running animation here
	pass

func update(_delta: float) -> void:
	if not player.is_on_floor():
		finished.emit(FALLING)
	elif Input.is_action_just_pressed("jump"):
		finished.emit(JUMPING)

func physics_update(delta: float) -> void:
	var input_dir : Vector2 = Input.get_vector("left", "right", "up", "down").normalized()
	#var direction : Vector3 = (player.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if input_dir:
		player.velocity.x = input_dir.x * player.speed
		player.velocity.z = input_dir.y * player.speed
	else:
		finished.emit(IDLE)
	player.move_and_slide()
