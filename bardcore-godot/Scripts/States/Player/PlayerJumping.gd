extends PlayerState
class_name PlayerJumping

func enter(previous_state_path: String, data := {}) -> void:
	player.velocity.y = player.jump_force
	#play jump animation here

func physics_update(_delta: float) -> void:
	player.velocity.y -= player.gravity * _delta
	
	var input_dir : Vector2 = Input.get_vector("left", "right", "up", "down").normalized()
	if input_dir:
		player.velocity.x = input_dir.x * player.speed
		player.velocity.z = input_dir.y * player.speed
	
	if player.velocity.y <= 0:
		finished.emit(FALLING)
	player.move_and_slide()
