extends Node

var level_dict : Dictionary
var map_folder = "res://Maps/"

func _ready() -> void:
	change_to_level("homebase")

func change_to_level(target_scene : String):
	GameManager.save_all_players()
	
	var scene_tree = get_tree()
	var map_path = map_folder + target_scene + ".tscn"
	scene_tree.call_deferred("change_scene_to_file", map_path)
	await scene_tree.scene_changed
	print(scene_tree.current_scene)
	connect_portals()

func connect_portals():
	var scene_tree = get_tree()
	var portals = scene_tree.get_nodes_in_group("Portal")
	for portal in portals:
		portal.on_enter_portal.connect(change_to_level)
