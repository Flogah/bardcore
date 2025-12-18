extends Node

signal game_state_changed(new_value)
signal building_time_changed(new_value)

enum gameState {
	home,
	combat,
	post_combat,
	shop,
}

# get's carried from map to map, so it's important to not have it be a single timer node
var starting_time:int = 5
# the time it takes to get to the next beat, better visualizing the time
var beat_time:float = 1.0
var standard_bonus_time:int = 2

var time_left:int
var max_time_value:int
var dragon_timer:Timer

var currentGameState : gameState


# this single variable could hold the unlocks in the village
var village_state: Dictionary = {
	"building_time": 1,
}

func _ready():
	load_village_state()
	
	create_dragon_timer()
	MusicManager.beat.connect(dragon_beat)
	reset_time()
	
	MapManager.entered_new_map.connect(add_dragon_time)
	UserInterface.update_progress_bar_max(max_time_value)
	UserInterface.update_time(time_left)

func _physics_process(delta: float):
	if dragon_timer && !dragon_timer.is_stopped():
		UserInterface.update_time(float(time_left) + dragon_timer.time_left - beat_time)

func dragon_beat():
	dragon_timer.start(beat_time)
	
	if currentGameState == gameState.home:
		return
	
	time_left -= 1
	UserInterface.update_time(time_left)
	if time_left < 1:
		dragon_death()

func add_dragon_time(time:int = standard_bonus_time):
	max_time_value += time
	time_left += time
	UserInterface.update_progress_bar_max(float(max_time_value))
	UserInterface.update_time(float(time_left))

func create_dragon_timer():
	dragon_timer = Timer.new()
	dragon_timer.one_shot = true
	add_child(dragon_timer)
	print("Dragon Timer created")

func dragon_death():
	add_building_time(max_time_value - time_left)
	reset_game()

func reset_time():
	time_left = starting_time
	max_time_value = starting_time

func convert_flee_time(time:float) -> int:
	# per 60 beats/per minute one day
	var days:int = roundi(time/60)
	var weeks:int = days/7
	#days -= weeks * 7
	
	print("Time survived: " + str(time))
	print("Days earned: " + str(days))
	print("Weeks earned: " + str(weeks))
	
	return days

func add_building_time(val:int):
	#building_time += convert_flee_time(val)
	village_state["building_time"] += 5
	building_time_changed.emit(village_state["building_time"])

func pay_building_cost(val: int) -> bool:
	if val > village_state["building_time"]:
		print("Not enough building time available. Cost: " + str(val) + ", Available: " + str(village_state["building_time"]))
		return false
	village_state["building_time"] -= val
	building_time_changed.emit(village_state["building_time"])
	print("Building Time: ", village_state["building_time"])
	return true

func get_building_time():
	return village_state["building_time"]

func set_building(b_name: String, level: int):
	village_state[b_name] = level

func get_building_lvl(b_name: String) -> int:
	if !village_state.has(b_name):
		return 0
	return village_state[b_name]

func reset_game():
	var loading_screen = preload("res://UserInterface/loading_screen.tscn").instantiate()
	get_tree().root.add_child(loading_screen)
	
	reset_time()
	MapManager.reset()
	MusicManager.reset()
	
	await get_tree().create_timer(1.0).timeout
	loading_screen.queue_free()
	
	get_tree().change_scene_to_packed(MapManager.HOMEBASE)

func change_gamestate(new_gamestate:gameState):
	currentGameState = new_gamestate
	game_state_changed.emit(currentGameState)

func save_village_state():
	var save_file = FileAccess.open("res://Save/Savegame.save", FileAccess.WRITE)
	
	var save_state = village_state
	
	var json_string = JSON.stringify(save_state)
	save_file.store_line(json_string)

func load_village_state():
	if !FileAccess.file_exists("res://Save/Savegame.save"):
		return
	
	var save_file = FileAccess.open("res://Save/Savegame.save", FileAccess.READ)
	
	#for line in save_file.get_length():
	var json_string = save_file.get_line()

	# Creates the helper class to interact with JSON.
	var json = JSON.new()
	# Check if there is any error while parsing the JSON string, skip in case of failure.
	var parse_result = json.parse(json_string)
	if not parse_result == OK:
		print("JSON Parse Error: ", json.get_error_message(), " in ", json_string, " at line ", json.get_error_line())
		
	var node_data = json.data
	
	village_state = node_data


func reset_all_progress():
	for key in village_state:
		village_state[key] = 0
	village_state["building_time"] = 1
	save_village_state()
