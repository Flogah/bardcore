extends CharacterBody3D
class_name Player

signal leave

@export var speed:float = 4.0
@export var jump_force:float = 5.0

var camera: Camera3D

@export var dash_force: float = 15.0
@export var dash_cooldown: float = 1.0
@export var dash_duration: float = 0.5

var gravity:float = ProjectSettings.get_setting("physics/3d/default_gravity")

var player: int
var input
var device

func init(player_num: int):
	player = player_num
	device = PlayerManager.get_player_device(player)
	input = DeviceInput.new(device)
	print(input)

func _physics_process(delta: float) -> void:
	# only in case movement_sm doesnt work
	#movement()
	if device < 0:
		point_to_mouse()
	else:
		look_direction()
	
	velocity.y -= gravity * delta
	move_and_slide()

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

func look_direction():
	var input_dir = input.get_vector("look_left", "look_right", "look_up", "look_down").normalized()
	if !input_dir:
		return
	rotation = Vector3(0, -input_dir.angle() - PI/2, 0)

func movement():
	var device = PlayerManager.get_player_device(player)
	var input_dir = MultiplayerInput.get_vector(device, "move_left", "move_right", "move_up", "move_down")
	
	if input_dir:
		velocity.x = input_dir.x * speed
		velocity.z = input_dir.y * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
