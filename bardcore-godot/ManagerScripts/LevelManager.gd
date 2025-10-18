extends Node

var level_dict : Dictionary
var map_folder = "res://Maps/"

func _ready() -> void:
	change_to_level("homebase")

func change_to_level(target_scene : String):
	var scene_tree = get_tree()
	scene_tree.change_scene_to_file(map_folder + target_scene + ".tscn")
	await scene_tree.scene_changed
	connect_portals()

func connect_portals():
	var scene_tree = get_tree()
	var portals = scene_tree.get_nodes_in_group("Portal")
	for portal in portals:
		portal.on_enter_portal.connect(change_to_level)
