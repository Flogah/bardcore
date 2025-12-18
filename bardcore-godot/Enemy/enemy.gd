class_name Enemy
extends CharacterBody3D

var gravity:float = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var blood_particles: GPUParticles3D = $BloodParticles
@onready var visual: Node3D = $Visual

@export var move_speed: float = 2

var dead: bool = false

func _physics_process(delta: float) -> void:
	if dead:
		return
	
	if visual.scale.y < 1.0:
		visual.scale.y += .02
	
	velocity.y -= gravity * delta
	move_and_slide()

func _on_health_component_died() -> void:
	dead = true
	get_parent().remove_child(self)
	queue_free()

func bleed():
	blood_particles.restart()
	squish()

func squish():
	visual.scale.y = .6
