extends Node

var player_nodes = {}

func _ready():
	PlayerManager.player_joined.connect(spawn_player)
	PlayerManager.player_left.connect(delete_player)

func _process(_delta):
	PlayerManager.handle_join_input()

func spawn_player(player: int):
	# create the player node
	var player_scene = preload("res://Player/player.tscn")
	var player_node = player_scene.instantiate()
	player_node.leave.connect(on_player_leave)
	player_nodes[player] = player_node
	player_node.init(player)
	
	# add the player to the tree
	#var current_scene = get_tree().current_scene
	var current_scene = MapManager.get_current_map()
	current_scene.add_child(player_node)
	
	# random spawn position
	player_node.position = Vector3(randf_range(-5, 5), 0, randf_range(-5, 5))
	player_node.set_playername()

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
	player_node.get_parent().remove_child(player_node)

func load_all_players():
	# puts all saved player nodes into the game
	for player in player_nodes:
		load_player(player)

func load_player(player: int):
	var player_node = player_nodes[player]
	get_tree().current_scene.add_child(player_node)
