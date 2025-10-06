extends PlayerState
class_name PlayerFalling

func enter(previous_state_path: String, data := {}) -> void:
	pass
	#enter falling animation here

func physics_update(_delta: float) -> void:
	player.velocity.y -= player.gravity * _delta
	
	if player.is_on_floor():
		finished.emit(RUNNING)
