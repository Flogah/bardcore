extends CharacterBody3D
class_name Player

@export var speed:float = 4.0
@export var jump_force:float = 5.0
var gravity:float = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var camera: Camera3D

@export var dash_force: float = 15.0
@export var dash_cooldown: float = 1.0
@export var dash_duration: float = 0.5

@export var soundVFX: PackedScene
@onready var trumpet_1: AudioStreamPlayer3D = $Audio/Trumpet1
@onready var trumpet_exit: Node3D = $Visual/TrumpetExit

@onready var trumpeting_area: Area3D = $EffectArea

func _process(delta: float) -> void:
	point_to_mouse()
	if Input.is_action_just_pressed("shoot"):
		shoot()

func _physics_process(delta: float) -> void:
	velocity.y -= gravity * delta

func point_to_mouse():
	var mouse_position = get_viewport().get_mouse_position()
	
	var camera = get_tree().get_first_node_in_group("Camera")
	
	var ray_origin = camera.project_ray_origin(mouse_position)
	var ray_normal = ray_origin + camera.project_ray_normal(mouse_position) * 1000
	
	var ray_query = PhysicsRayQueryParameters3D.create(ray_origin, ray_normal)
	
	ray_query.collide_with_bodies = true
	
	var space_state = get_world_3d().direct_space_state
	var ray_result = space_state.intersect_ray(ray_query)
	
	if !ray_result.is_empty():
		var look_at_position = Vector3(ray_result.position.x, position.y ,ray_result.position.z)
		look_at(look_at_position)

func shoot():
	trumpet_1.play()
	var new_vfx = soundVFX.instantiate()
	trumpet_exit.add_child(new_vfx)
	new_vfx.global_position = trumpet_exit.global_position
	
	var trumpeted_bodies = trumpeting_area.get_overlapping_bodies()
	var hit_enemies : Array
	for body in trumpeted_bodies:
		if body.is_in_group("Enemy"):
			hit_enemies.append(body)
	
	for enemy in hit_enemies:
		var dir = (enemy.global_position - global_position).normalized()
		enemy.velocity = dir * 200
		enemy.velocity.y = 3
		enemy.move_and_slide()
