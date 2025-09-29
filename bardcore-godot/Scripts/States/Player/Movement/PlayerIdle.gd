extends PlayerState
class_name PlayerMoveIdle

func enter(previous_state_path: String, data := {}) -> void:
	player.velocity = Vector3.ZERO
	# play idle animation

func physics_update(_delta: float) -> void:
	#player.velocity.y += player.gravity * _delta
	player.velocity.x = move_toward(player.velocity.x, 0, player.speed)
	player.velocity.z = move_toward(player.velocity.z, 0, player.speed)
	var input_dir : Vector2 = Input.get_vector("left", "right", "up", "down")
	if input_dir:
		finished.emit(RUNNING)
