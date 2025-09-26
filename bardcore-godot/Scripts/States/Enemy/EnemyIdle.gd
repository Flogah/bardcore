extends State
class_name EnemyIdle

@export var move_speed: float = 1

var move_direction : Vector3
var wander_time : float

#func randomize_wander():
	#move_direction = Vector3(randf_range(-1, 1), 0, randf_range(-1, 1)).normalized()
	#wander_time = randf_range(1.0, 3.0)
#
#func enter():
	#super()
	#randomize_wander()
#
#func update(delta:float):
	#if wander_time > 0:
		#wander_time -= delta
	#else:
		#randomize_wander()
#
#func physics_update(delta: float) -> void:
	#pass
	##currentStateOwner.velocity = move_direction * move_speed
