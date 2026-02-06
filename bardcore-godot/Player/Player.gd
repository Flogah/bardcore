extends CharacterBody3D
class_name Player

signal leave
signal knocked_out
signal back_on_feet

const TRUMPET = preload("res://Instrument/trumpet.tscn")
const FIDEL = preload("res://Instrument/Fidel.tscn")

const LOVER = preload("res://BlenderScenes/lover_in_pose_2.tscn")

enum bard_type {
	lover
}

@onready var type: bard_type
var bard_model: Node3D

@onready var player_name: Label3D = $PlayerName
@onready var instrument_spawn: Node3D = $InstrumentSpawn
@onready var visual: Node3D = $Visual

@onready var interaction_area: Area3D = $InteractionArea

@export var dash_force: float = 50.0
@export var dash_cooldown: float = 2.0
@export var dash_duration: float = 0.1

@export var stat_comp: stat_component
@export var inventory: inventory_component
@export var health_comp: health_component

@export var animation_player: AnimationPlayer
@export var hitbox: CollisionShape3D


@export var indicator_ring: Node3D
@export var player_colors : PackedColorArray = [
	Color.BLUE,
	Color.GREEN,
	Color.YELLOW,
	Color.BLACK,
	Color.WHITE,
	Color.RED,
]

var can_move: bool = true
var can_interact: bool = true
var can_attack: bool = true

var gravity:float = ProjectSettings.get_setting("physics/3d/default_gravity")
var camera: Camera3D
var player: int
var input
var device
var equipped_instrument

func init(player_num: int):
	player = player_num
	device = PlayerManager.get_player_device(player)
	input = DeviceInput.new(device)

func _ready() -> void:
	if !equipped_instrument:
		add_instrument(TRUMPET)
	equip_next_bard()
	set_colors()

func _physics_process(delta: float) -> void:
	# only in case movement_sm doesnt work
	#movement()
	if device < 0:
		point_to_mouse()
	else:
		look_direction()
	
	velocity.y -= gravity * delta
	
	if !can_move:
		velocity = Vector3.ZERO
	move_and_slide()
	
	if MultiplayerInput.is_action_just_pressed(device, "interact"):
		try_interact()
	
	if GameManager.currentGameState == GameManager.gameState.home:
		if MultiplayerInput.is_action_just_pressed(device, "next_instrument"):
			equip_next_instrument()
		if MultiplayerInput.is_action_just_pressed(device, "next_bard"):
			equip_next_bard()
	
	# only keyboard can escape to main menu
	if MultiplayerInput.is_action_just_pressed(-1, "escape"):
		GameManager.save_village_state()
		get_tree().change_scene_to_file("res://Menus/main_menu.tscn")

func point_to_mouse():
	if !can_move:
		return
	
	var mouse_position = get_viewport().get_mouse_position()
	
	camera = get_tree().get_first_node_in_group("Camera")
	
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
	if !can_move:
		return
	
	var input_dir = input.get_vector("look_left", "look_right", "look_up", "look_down").normalized()
	if !input_dir:
		return
	rotation = Vector3(0, -input_dir.angle() - PI/2, 0)

#func movement():
	#
	#device = PlayerManager.get_player_device(player)
	#var input_dir = MultiplayerInput.get_vector(device, "move_left", "move_right", "move_up", "move_down")
	#
	#if input_dir:
		#velocity.x = input_dir.x * stat_comp.get_stat(stat_comp.stat_id.MOVEMENT_SPEED)
		#velocity.z = input_dir.y * stat_comp.get_stat(stat_comp.stat_id.MOVEMENT_SPEED)
	#else:
		#velocity.x = move_toward(velocity.x, 0, stat_comp.get_stat(stat_comp.stat_id.MOVEMENT_SPEED))
		#velocity.z = move_toward(velocity.z, 0, stat_comp.get_stat(stat_comp.stat_id.MOVEMENT_SPEED))

func set_playername():
	player_name.set_text("P " + str(player))

func add_instrument(instrument):
	if equipped_instrument:
		equipped_instrument.queue_free()
	var instrument_instance = instrument.instantiate()
	instrument_instance.position = instrument_spawn.position
	add_child(instrument_instance)
	equipped_instrument = instrument_instance

func equip_next_instrument():
	if equipped_instrument.type == Instrument.instrument_type.trumpet:
		add_instrument(FIDEL)
	else:
		add_instrument(TRUMPET)

func equip_next_bard():
	if bard_model:
		bard_model.queue_free()
	var new_model = LOVER.instantiate()
	visual.add_child(new_model)
	bard_model = new_model
	type = bard_type.lover

func set_colors():
	var col = player_colors[player]
	PlayerManager.set_player_color(player, col)
	#print(PlayerManager.get_player_color(player))
	#var mat = StandardMaterial3D.new()
	#mat.albedo_color = col
	#var meshes = visual.get_children()
	#for mesh in meshes:
		#mesh.set_surface_override_material(0, mat)
	indicator_ring.set_color(col)

func try_interact():
	if !can_interact:
		return
	
	var interactables = interaction_area.get_overlapping_areas()
	for thing in interactables:
		var ia: Interactable = thing.owner
		if ia is droppable_item:
			inventory.pickup(ia)
			return
		else:
			ia.interact()

func _on_health_component_died() -> void:
	hitbox.disabled = true
	animation_player.play("die")
	can_attack = false
	can_interact = false
	can_move = false
	knocked_out.emit()

func full_restore():
	hitbox.disabled = false
	animation_player.play_backwards("die")
	health_comp.heal(health_comp.max_health)
	can_attack = true
	can_interact = true
	can_move = true
	back_on_feet.emit()
