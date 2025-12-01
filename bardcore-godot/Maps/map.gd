extends Node3D
class_name Map

@export var camera: Camera3D
@export var mapGameState : GameManager.gameState

@export var right_portal:Portal
@export var left_portal:Portal

@export var spawn_position:Node3D

@onready var enemy_nodes: Node3D = $Enemies
@onready var exit_nodes: Node3D = $Exits
@onready var bits: Node3D = $Bits

var enemies = []
var portals = []

func _ready() -> void:
	read_map()
	shuffle_boxes()
	#MusicManager.beat.connect(screenshake)

func read_map():
	for enemy in enemy_nodes.get_children():
		enemies.append(enemy)
	for portal in exit_nodes.get_children():
		portals.append(portal)
	connect_portals()

func connect_portals():
	if right_portal:
		right_portal.on_enter_portal.connect(exit_right)
	if left_portal:
		left_portal.on_enter_portal.connect(exit_left)

func exit_left():
	MapManager.go_left()

func exit_right():
	MapManager.go_right()

func spawn_players():
	if PlayerManager.player_nodes.is_empty():
		return
	
	var entrance

	if spawn_position:
		entrance = spawn_position.global_position
	elif MapManager.coming_from_left:
		entrance = left_portal.spawn_center.global_position
	else:
		entrance = right_portal.spawn_center.global_position
	
	var player_nodes = PlayerManager.player_nodes
	
	for player_node in player_nodes:
		var player = player_nodes[player_node]
		#var cur_scene = get_tree().get_current_scene()
		var cur_scene = MapManager.get_current_map()
		if cur_scene:
			cur_scene.add_child(player)
			player.position = entrance
			entrance.z += 2.0
	
	if mapGameState != GameManager.gameState.home:
		UserInterface.show()

func unlock_all_portals():
	for portal in portals:
		portal.unlock()
	
func lock_all_portals():
	for portal in portals:
		portal.lock()

func lock_unlock_all_portals():
	lock_all_portals()
	var unlock_timer = Timer.new()
	unlock_timer.one_shot = true
	unlock_timer.autostart = true
	unlock_timer.timeout.connect(unlock_all_portals)
	add_child(unlock_timer)

func shuffle_boxes():
	var boxes = bits.get_children()
	for box in boxes:
		box.position += Vector3(randf_range(-1, 1), 0, randf_range(-1, 1))

#func screenshake(strength:float = 0.2, fade:float = 0.3):
	#camera.screen_shake(strength, fade)
