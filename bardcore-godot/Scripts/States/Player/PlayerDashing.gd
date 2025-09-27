extends PlayerState
class_name PlayerDashing

@export var dash_cooldown_timer: Timer
var cur_dash_duration : float = -1

var dash_direction: Vector3

func enter(previous_state_path: String, data := {}) -> void:
	var input_dir: Vector2 = Input.get_vector("left", "right", "up", "down").normalized()
	dash_direction = Vector3(input_dir.x, 0, input_dir.y)
	cur_dash_duration = player.dash_duration
	print(cur_dash_duration)

func physics_update(_delta: float) -> void:
	player.global_position += dash_direction * player.dash_force * _delta
	cur_dash_duration -= _delta
	player.move_and_slide()
	
	if cur_dash_duration < 0:
		cur_dash_duration = -1
		var input_dir: Vector2 = Input.get_vector("left", "right", "up", "down").normalized()
		if input_dir:
			finished.emit(RUNNING)
		else:
			finished.emit(IDLE)
