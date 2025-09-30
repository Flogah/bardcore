extends PlayerState
class_name PlayerDashing

var dash_cooldown_timer: Timer
var dash_duration_timer: Timer

var dash_direction: Vector3

func enter(previous_state_path: String, data := {}) -> void:
	if !dash_cooldown_timer:
		print("No cooldown timer found. Creating new timer.")
		dash_cooldown_timer = Timer.new()
		add_child(dash_cooldown_timer)
		dash_cooldown_timer.one_shot = true
	
	if !dash_duration_timer:
		print("No duration timer found. Creating new timer.")
		dash_duration_timer = Timer.new()
		add_child(dash_duration_timer)
		dash_duration_timer.one_shot = true
	
	if !dash_cooldown_timer.is_stopped():
		print("Dash is still on cooldown. Time left: " + str(dash_cooldown_timer.time_left))
		finished.emit(RUNNING)
		return
	
	dash_cooldown_timer.start(player.dash_cooldown)
	dash_duration_timer.start(player.dash_duration)
	
	var input_dir: Vector2 = Input.get_vector("left", "right", "up", "down").normalized()
	dash_direction = Vector3(input_dir.x, 0, input_dir.y)

func physics_update(_delta: float) -> void:
	player.global_position += dash_direction * player.dash_force * _delta
	
	if dash_duration_timer.is_stopped():
		finished.emit(RUNNING)
