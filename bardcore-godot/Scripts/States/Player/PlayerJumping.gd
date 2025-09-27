extends PlayerState
class_name PlayerJumping

func enter(previous_state_path: String, data := {}) -> void:
	player.velocity.y = player.jump_force
	#play jump animation here

func physics_update(_delta: float) -> void:
	player.velocity.y -= player.gravity * _delta
	
	if player.velocity.y <= 0:
		finished.emit(FALLING)
	player.move_and_slide()
