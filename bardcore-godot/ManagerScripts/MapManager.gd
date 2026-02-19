extends Node

signal entered_new_map

const HOMEBASE = preload("uid://cr1ydxfa4aiik")

var combat_maps = []
var current_map : Map
var coming_from_left: bool = true
var map_grid : Dictionary[Vector2i, Map] = {}
var current_grid_position : Vector2i = Vector2i(0,0)

func _ready() -> void:
	read_all_maps()

func read_all_maps():
	var dirs = ResourceLoader.list_directory("res://Maps/CombatMaps")
	for dir in dirs:
		combat_maps.append("res://Maps/CombatMaps/" + dir)

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

func random_map() -> PackedScene:
	var rand = combat_maps[randi_range(0, combat_maps.size()-1)]
	var rand_map = load(rand)
	return rand_map

func unload_map():
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
