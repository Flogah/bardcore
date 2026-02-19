class_name Enemy
extends CharacterBody3D

signal died

var gravity:float = ProjectSettings.get_setting("physics/3d/default_gravity")
@onready var blood_particles: GPUParticles3D = $BloodParticles
@onready var visual: Node3D = $Visual
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var statemachine = $StateMachine
@export var health_comp: health_component
@export var move_speed: float = 2

var target: Player

var dead: bool = false

func _ready() -> void:
	MapManager.current_map.bards_spawned.connect(engage)

func _physics_process(delta: float) -> void:
	if visual.scale.y < 1.0:
		visual.scale.y += .02
	
	move_and_slide()

func _on_health_component_died() -> void:
	dead = true
	statemachine._transition_to_next_state("EnemyDead")

func bleed(_amount, _mod_amount, _total):
	blood_particles.restart()
	squish()

func squish():
	visual.scale.y = .6

func engage():
	var player_num = PlayerManager.player_nodes.size()
	var new_max_health = health_comp.max_health
	for num in player_num:
		new_max_health *= 1.2
	health_comp.set_health(new_max_health)
	statemachine._transition_to_next_state("EnemyFollow")
	

func target_bard():
	if !target:
		find_new_target()

func find_new_target():
	var potential_targets = []
	for bard in MapManager.current_map.bards:
		if bard.can_attack:
			potential_targets.append(bard)
	
	potential_targets.shuffle()
	if potential_targets:
		target = potential_targets[0]
		target.knocked_out.connect(find_new_target)
