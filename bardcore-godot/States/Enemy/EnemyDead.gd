extends State
class_name EnemyDead

@export var animation_player: AnimationPlayer
@export var receiver: CollisionShape3D

func enter(previous_state_path: String, data := {}) -> void:
	owner.died.emit()
	animation_player.play("die")
	receiver.disabled = true
