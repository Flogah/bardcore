extends State
class_name EnemyFollow

var follow_target:CharacterBody3D

func enter(_previous_state_path: String, _data := {}) -> void:
	var target = PlayerManager.player_nodes[randi_range(0, PlayerManager.player_nodes.size()-1)]
	follow_target = target

func physics_update(_delta: float) -> void:
	var direction = (follow_target.global_position - owner.global_position)
	owner.velocity.x = direction.normalized().x * owner.move_speed
	owner.velocity.z = direction.normalized().z * owner.move_speed
	owner.move_and_slide()
