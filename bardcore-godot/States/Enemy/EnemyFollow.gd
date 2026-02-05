extends State
class_name EnemyFollow

@export var animation_player: AnimationPlayer

var threat_range: float = 2.0

func enter(_previous_state_path: String, _data := {}) -> void:
	animation_player.play("idle")
	
	owner.target_bard()

func physics_update(_delta: float) -> void:
	if !owner.target.is_inside_tree():
		return
	
	owner.look_at(owner.target.global_position)
	
	var direction = (owner.target.global_position - owner.global_position)
	owner.velocity.x = direction.normalized().x * owner.move_speed
	owner.velocity.z = direction.normalized().z * owner.move_speed
	
	if direction.length() < threat_range:
		finished.emit("ThreatenAttack")
	
	owner.move_and_slide()

func exit():
	owner.velocity = Vector3.ZERO
	owner.move_and_slide()
