extends State
class_name EnemyFollow

@export var move_speed: float = 2

var follow_target:CharacterBody3D

#func enter():
	#follow_target = get_tree().get_first_node_in_group("Player")
#
#func physics_update(delta: float) -> void:
	#var direction = (follow_target.global_position - stateOwner.global_position)
	#if direction.length() > 1.5:
		#stateOwner.velocity = direction.normalized() * move_speed
	#else:
		#stateOwner.velocity = Vector3()
