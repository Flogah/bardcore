extends Node3D
class_name Map

@export var home : bool = false

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
	if !home:
		spawn_players()

func spawn_players():
	# TODO get access to all players and place them at the entrance
	# compat with multiplayer spawning in
	var portals = get_tree().get_nodes_in_group("Portal")
	var entrance
	for portal in portals:
		if portal.entrance:
			entrance = portal
	
	var player_nodes = GameManager.player_nodes
	var entrance_position = entrance.spawn_center.global_position
	for player_node in player_nodes:
		GameManager.load_player(player_node)
		player_nodes[player_node].position = entrance_position
		entrance_position.z += 2.0
	
	lock_all_portals()
	var unlock_timer = Timer.new()
	unlock_timer.one_shot = true
	unlock_timer.autostart = true
	unlock_timer.timeout.connect(unlock_all_portals)
	add_child(unlock_timer)
	
	# if it's a combat map, lock all entrances
	#if enemies.size() > 0:
		#lock_all_portals()

#func _on_enemy_dies():
	#if enemies.size() > 0:
		#return
	#unlock_all_portals()

func unlock_all_portals():
	for portal in portals:
		portal.unlock()
	
func lock_all_portals():
	for portal in portals:
		portal.lock()
