extends State
class_name EnemyIdle

@export var move_speed: float = 1

var move_direction : Vector3
var wander_time : float

func randomize_wander():
	move_direction = Vector3(randf_range(-1.0, 1.0), 0.0, randf_range(-1.0, 1.0)).normalized()
	wander_time = randf_range(1.0, 3.0)

func enter(previous_state_path: String, data := {}) -> void:
	randomize_wander()

func update(_delta: float) -> void:
	if owner.dead:
		finished.emit("EnemyDead")
	
	return
	if wander_time > 0:
		wander_time -= _delta
	else:
		randomize_wander()

func physics_update(_delta: float) -> void:
	owner.velocity = move_direction * move_speed
