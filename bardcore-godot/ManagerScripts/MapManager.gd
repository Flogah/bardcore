extends Node

const HOMEBASE = "uid://cr1ydxfa4aiik"

var map_array = [
	HOMEBASE,
]
var combat_maps = []
var current_map_iterator:int = 0
var current_map : Map
var coming_from_left: bool = true

func _ready() -> void:
	read_all_combat_maps()
	load_map(map_array[0])

func read_all_combat_maps():
	var dirs = ResourceLoader.list_directory("res://Maps/CombatMaps")
	for dir in dirs:
		combat_maps.append("res://Maps/CombatMaps/" + dir)

func go_to_previous_map():
	GameManager.save_all_players()
	current_map_iterator -= 1
	coming_from_left = false
	
	if current_map_iterator < 0:
		current_map_iterator = 0
	
	load_map(map_array[current_map_iterator])

func go_to_next_map():
	GameManager.save_all_players()
	current_map_iterator += 1
	coming_from_left = true
	
	if map_array.size() < current_map_iterator:
		load_map(map_array[current_map_iterator])
	else:
		map_array.append(random_battle_map_path())
		load_map(map_array[current_map_iterator])

func random_battle_map_path() -> String:
	var rand = combat_maps[randi_range(0, combat_maps.size()-1)]
	return rand

func load_map(target_map : String):
	var scene_tree = get_tree()
	scene_tree.call_deferred("change_scene_to_file", target_map)
	await scene_tree.scene_changed
