extends Node

# player is 0-3
# device is -1 for keyboard/mouse, 0+ for joypads
# these concepts seem similar but it is useful to separate them so for example, device 6 could control player 1.

signal player_joined(player)
signal player_spawned(player)
signal player_left(player)

signal player_data_updated(player)

enum bard_type {
	lover,
	relic,
	star
}

var player_colors : PackedColorArray = [
	Color(0.142, 0.118, 0.79, 1.0),
	Color(0.0, 0.615, 0.0),
	Color(0.774, 0.774, 0.0),
	Color(0.0, 0.0, 0.0),
	Color(1.0, 1.0, 1.0),
	Color(0.166, 0.529, 0.58)
]

# map from player integer to dictionary of data
# the existence of a key in this dictionary means this player is joined.
# use get_player_data() and set_player_data() to use this dictionary.
var player_data: Dictionary = {}

const MAX_PLAYERS = 4

var player_nodes = {}

func _ready():
	player_joined.connect(spawn_player)
	player_left.connect(delete_player)

func _unhandled_input(event: InputEvent) -> void:
	handle_join_input()

func spawn_player(player: int):
	# create the player node
	var player_scene = preload("res://Player/player.tscn")
	var player_node = player_scene.instantiate()
	player_node.leave.connect(on_player_leave)
	player_nodes[player] = player_node
	player_node.init(player)
	
	# add the player to the tree
	#var current_scene = get_tree().current_scene
	var current_scene = get_tree().current_scene
	if !current_scene:
		current_scene = MapManager.get_current_map()
	current_scene.add_child(player_node)
	
	# random spawn position
	player_node.position = Vector3(randf_range(-5, 5), 0, randf_range(-5, 5))
	player_node.set_playername()
	apply_village_upgrades()
	player_spawned.emit(player)

func delete_player(player: int):
	player_nodes[player].queue_free()
	player_nodes.erase(player)

func on_player_leave(player: int):
	# just let the player manager know this player is leaving
	# this will, through the player manager's "player_left" signal,
	# indirectly call delete_player because it's connected in this file's _ready()
	PlayerManager.leave(player)

func save_all_players():
	# this removes the player node from the tree, but without deleting it outright
	# this way, the player and all its children nodes are safe
	for player in player_nodes:
		save_player(player)

func save_player(player:int):
	var player_node = player_nodes[player]
	if !player_node.is_inside_tree():
		return
	# this one is to avoid portals triggering their detection twice when switching maps
	player_node.global_position = Vector3.UP * 1000.0
	player_node.get_parent().remove_child(player_node)

func load_all_players():
	# puts all saved player nodes into the game
	for player in player_nodes:
		load_player(player)

func load_player(player: int):
	var player_node = player_nodes[player]
	MapManager.current_map.add_child(player_node)

func join(device: int):
	var player = next_player()
	if player >= 0:
		# initialize default player data here
		# drunk, trumpet are examples
		player_data[player] = {
			"device": device,
			"bard": bard_type.lover,
			"instrument": "trumpet",
			"color": player_colors[player],
		}
		player_joined.emit(player)

func leave(player: int):
	if player_data.has(player):
		player_data.erase(player)
		player_left.emit(player)

func get_player_count():
	return player_data.size()

func get_player_indexes():
	return player_data.keys()

func get_player_device(player: int) -> int:
	return get_player_data(player, "device")

func get_player_color(player: int) -> Color:
	return get_player_data(player, "color")

# get player data.
# null means it doesn't exist.
func get_player_data(player: int, key: StringName):
	if player_data.has(player) and player_data[player].has(key):
		return player_data[player][key]
	return null

# set player data to get later
func set_player_data(player: int, key: StringName, value: Variant):
	# if this player is not joined, don't do anything:
	if !player_data.has(player):
		return
	
	player_data[player][key] = value
	
	player_data_updated.emit()

# call this from a loop in the main menu or anywhere they can join
# this is an example of how to look for an action on all devices
func handle_join_input():
	for device in get_unjoined_devices():
		if MultiplayerInput.is_action_just_pressed(device, "join"):
			join(device)

# to see if anybody is pressing the "start" action
# this is an example of how to look for an action on all players
# note the difference between this and handle_join_input(). players vs devices.
func someone_wants_to_start() -> bool:
	for player in player_data:
		var device = get_player_device(player)
		if MultiplayerInput.is_action_just_pressed(device, "start"):
			return true
	return false

func is_device_joined(device: int) -> bool:
	for player_id in player_data:
		var d = get_player_device(player_id)
		if device == d: return true
	return false

# returns a valid player integer for a new player.
# returns -1 if there is no room for a new player.
func next_player() -> int:
	for i in MAX_PLAYERS:
		if !player_data.has(i): return i
	return -1

# returns an array of all valid devices that are *not* associated with a joined player
func get_unjoined_devices():
	var devices = Input.get_connected_joypads()
	# also consider keyboard player
	devices.append(-1)
	
	# filter out devices that are joined:
	return devices.filter(func(device): return !is_device_joined(device))

func reset():
	player_nodes = {}

func apply_village_upgrades():
	var homebase = get_tree().current_scene
	if !homebase: return
	var buildings = homebase.buildings_node.get_children()
	if !buildings: return
	
	for build in buildings:
		for target_player in player_nodes:
			if player_nodes[target_player] and is_instance_valid(player_nodes[target_player]):
				var stats = player_nodes[target_player].stat_comp
				stats.remove_upgrades(build.get_instance_id())
				var b_upgrade: upgrade = build.get_current_upgrade()
				if b_upgrade:
					var upgrade_arr: Array[upgrade] = [b_upgrade]
					player_nodes[target_player].stat_comp.add_upgrades(build.get_instance_id(), upgrade_arr)
