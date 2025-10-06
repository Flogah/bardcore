extends CharacterBody3D

var gravity:float = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var move_speed: float = 2

func _physics_process(delta: float) -> void:
	velocity.y -= gravity * delta
