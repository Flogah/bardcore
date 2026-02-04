class_name Enemy
extends CharacterBody3D

signal died

var gravity:float = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var blood_particles: GPUParticles3D = $BloodParticles
@onready var visual: Node3D = $Visual
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var move_speed: float = 2

func _physics_process(delta: float) -> void:
	if visual.scale.y < 1.0:
		visual.scale.y += .02
	
	move_and_slide()

func _on_health_component_died() -> void:
	var statemachine = $StateMachine
	statemachine._transition_to_next_state("EnemyDead")

func bleed(_amount, _mod_amount, _total):
	blood_particles.restart()
	squish()

func squish():
	visual.scale.y = .6
