extends Node3D
class_name Map

@onready var enemy_nodes: Node3D = $Enemies
@onready var exit_nodes: Node3D = $Exits

var enemies = []
var portals = []

func _ready() -> void:
	for enemy in enemy_nodes.get_children():
		enemies.append(enemy)
		# TODO add signal.connect when an enemy dies, so we can check if it's safe
	for portal in exit_nodes.get_children():
		portals.append(portal)
	
	spawn_players()
	
	for portal in portals:
		if portal.entrance:
			portal.on_enter_portal.connect(enter_previous_map)
		else:
			portal.on_enter_portal.connect(enter_next_map)

func enter_previous_map():
	MapManager.go_to_previous_map()

func enter_next_map():
	MapManager.go_to_next_map()

func spawn_players():
	# TODO get access to all players and place them at the entrance
	# compat with multiplayer spawning in
	if GameManager.player_nodes.is_empty():
		return
	
	var portals = get_tree().get_nodes_in_group("Portal")
	var entrance
	
	# do we need to spawn players on the left side or the right side?
	# and which portal is left, which is right?
	if MapManager.coming_from_left:
		if portals[0].position.x <= 0:
			entrance = portals[0]
		else:
			entrance = portals[1]
	else:
		if portals[0].position.x >= 0:
			entrance = portals[0]
		else:
			entrance = portals[1]
	
	var player_nodes = GameManager.player_nodes
	var entrance_position = entrance.spawn_center.global_position
	for player_node in player_nodes:
		var player = player_nodes[player_node]
		get_tree().current_scene.add_child(player)
		player.position = entrance_position
		entrance_position.z += 2.0
	
	# for testing, so we can actually see the locking and unlocking
	#lock_all_portals()
	#var unlock_timer = Timer.new()
	#unlock_timer.one_shot = true
	#unlock_timer.autostart = true
	#unlock_timer.timeout.connect(unlock_all_portals)
	#add_child(unlock_timer)

func unlock_all_portals():
	for portal in portals:
		portal.unlock()
	
func lock_all_portals():
	for portal in portals:
		portal.lock()
