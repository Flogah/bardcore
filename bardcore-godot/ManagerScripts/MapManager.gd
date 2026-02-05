extends Node

signal entered_new_map

const HOMEBASE = preload("uid://cr1ydxfa4aiik")

var combat_only_maps_weight: int = 5
var combat_and_treasure_maps_weight: int = 10
var treasure_maps_weight: int = 1

var combat_only_maps = [
	preload("res://Maps/CombatMaps/combat_1.tscn"),
	preload("res://Maps/CombatMaps/combat_2.tscn"),
]

var combat_and_treasure_maps = [
	preload("res://Maps/CombatMaps/combat_3.tscn"),
]

var tresure_maps = [
	preload("res://Maps/CombatMaps/treasure_room.tscn"),
]

var current_map : Map
var coming_from_left: bool = true
var map_grid : Dictionary[Vector2i, Map] = {}
var current_grid_position : Vector2i = Vector2i(0,0)

#func _ready() -> void:
	#read_all_maps()
#
#func read_all_maps():
	#var dirs = ResourceLoader.list_directory("res://Maps/CombatMaps")
	#for dir in dirs:
		#combat_maps.append("res://Maps/CombatMaps/" + dir)

func get_current_map() -> Map:
	return current_map

func get_map_at_pos(pos: Vector2i) -> Map:
	return get_map(pos)

func set_current_map(map: Map):
	current_map = map

func get_map(pos : Vector2i) -> Map:
	var m = map_grid.get(pos)
	if !m:
		m = random_map().instantiate()
		map_grid[pos] = m
		entered_new_map.emit()
	return m

#func random_map() -> PackedScene:
	#var rand = combat_maps[randi_range(0, combat_maps.size()-1)]
	#var rand_map = load(rand)
	#return rand_map

func random_map() -> PackedScene:
	var rand = randi_range(0, treasure_maps_weight+combat_only_maps_weight+combat_and_treasure_maps_weight)
	if rand <= treasure_maps_weight:
		return random_out_array(tresure_maps)
	elif rand <= treasure_maps_weight+combat_only_maps_weight:
		return random_out_array(combat_only_maps)
	else:
		return random_out_array(combat_and_treasure_maps)
	printerr("Something went wrong in random Map loading!")
	return combat_only_maps[0]

func random_out_array(map_array: Array) -> PackedScene:
	var rand_map = map_array[randi_range(0, map_array.size()-1)]
	return rand_map

func unload_map():
	if !current_map:
		return
	PlayerManager.save_all_players()
	
	if get_tree().current_scene:
		get_tree().current_scene.queue_free()
	
	if current_map:
		#TODO do some cleanup of temporary assets if possible
		var root = get_tree().get_root()
		root.remove_child.call_deferred(current_map)

func load_map(pos: Vector2i = current_grid_position) -> void:
	unload_map()
	var root = get_tree().get_root()
	var map_to_load = get_map(pos)
	root.add_child.call_deferred(map_to_load)
	current_grid_position = pos
	set_current_map(map_to_load)
	
	await get_tree().create_timer(.2).timeout
	current_map.spawn_players()
	GameManager.change_gamestate(current_map.mapGameState)

func go_right():
	print("Going right!")
	var map_r = current_grid_position + Vector2i(1,0)
	coming_from_left = true
	load_map(map_r)

func go_left():
	print("Going left!")
	var map_l = current_grid_position - Vector2i(1,0)
	coming_from_left = false
	load_map(map_l)

func reset():
	unload_map()
	map_grid = {}
	coming_from_left = true
