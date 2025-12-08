extends Map

@export var spawn_position:Node3D

@export var exit_portal:Portal

func _ready() -> void:
	exit_portal.on_enter_portal.connect(enter_run)

func enter_run():
	MapManager.load_map()

func spawn_players():
	if PlayerManager.player_nodes.is_empty():
		return
	
	var entrance = spawn_position.global_position
	
	var player_nodes = PlayerManager.player_nodes
	
	for player_node in player_nodes:
		var player = player_nodes[player_node]
		#var cur_scene = get_tree().get_current_scene()
		var cur_scene = MapManager.get_current_map()
		if cur_scene:
			cur_scene.add_child(player)
			player.position = entrance
			entrance.z += 2.0
