extends CharacterBody3D

var gravity:float = ProjectSettings.get_setting("physics/3d/default_gravity")

@export var move_speed: float = 2

func _physics_process(delta: float) -> void:
	velocity.y -= gravity * delta
	move_and_slide()

func _on_health_component_died() -> void:
	queue_free()
