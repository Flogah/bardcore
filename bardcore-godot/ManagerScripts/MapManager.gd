extends Node

const HOMEBASE = preload("uid://cr1ydxfa4aiik")

var map_array = [
	HOMEBASE,
]
var combat_maps = []
var current_map_iterator:int = 0
var current_map : Map
var coming_from_left: bool = true

# grid is for now assumed to be 5x5
var map_grid : Dictionary[Vector2i, Map] = {}
var current_grid_position : Vector2i

func _ready() -> void:
	var homebase_instance = HOMEBASE.instantiate()
	map_grid[Vector2i(0,2)] = homebase_instance
	current_grid_position = Vector2i(0,2)
	
	read_all_combat_maps()
	
	unload_map()
	load_map(current_grid_position)

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
	
	change_scene_to(map_array[current_map_iterator])

func go_to_next_map():
	GameManager.save_all_players()
	current_map_iterator += 1
	coming_from_left = true
	
	if map_array.size() < current_map_iterator:
		change_scene_to(map_array[current_map_iterator])
	else:
		map_array.append(random_battle_map_path())
		change_scene_to(map_array[current_map_iterator])

func random_battle_map_path() -> String:
	var rand = combat_maps[randi_range(0, combat_maps.size()-1)]
	return rand

func change_scene_to(target_map : String):
	var scene_tree = get_tree()
	scene_tree.call_deferred("change_scene_to_file", target_map)
	await scene_tree.scene_changed

######################

func get_current_map() -> Map:
	return current_map

func get_map(pos : Vector2i) -> Map:
	var m = map_grid[pos]
	if !m:
		m = get_random_map().instantiate()
	return m

func get_random_map() -> Map:
	var rand = combat_maps[randi_range(0, combat_maps.size()-1)]
	var rand_map = rand.instantiate()
	return rand_map

func unload_map():
	GameManager.save_all_players()
	var root = get_tree().get_root()
	var cur_scene = get_tree().current_scene
	root.remove_child(cur_scene)

func load_map(_pos: Vector2i) -> void:
	unload_map()
	var root = get_tree().get_root()
	var map_to_load = get_map(_pos)
	root.add_child(map_to_load)
	get_tree().set_current_scene(map_to_load)

func go_right():
	var map_r = current_grid_position + Vector2i(1,0)
	coming_from_left = true
	load_map(map_r)

func go_left():
	var map_l = current_grid_position + Vector2i(-1,0)
	coming_from_left = false
	load_map(map_l)
