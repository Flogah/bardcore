extends Node3D
class_name Map

@onready var enemy_nodes: Node3D = $Enemies
@onready var exit_nodes: Node3D = $Exits

var enemies = []
var connected_maps = []
var portals = []
# connections is a dictionary that can later hold every portal, and its associated target map
# needs some kind of map_manager to hold all the connections
var connections = {}

func _ready() -> void:
	for enemy in enemy_nodes.get_children():
		enemies.append(enemy)
		# TODO add signal.connect when an enemy dies, so we can check if it's safe
	for portal in exit_nodes.get_children():
		portals.append(portal)

func spawn_players():
	# TODO get access to all players and place them at the entrance
	# compat with multiplayer spawning in
	# if it's a combat map, lock all entrances
	if enemies.size() > 0:
		lock_all_portals()

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
