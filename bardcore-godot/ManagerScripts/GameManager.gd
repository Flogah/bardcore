extends Node

# get's carried from map to map, so it's important to not have it be a single timer node
var starting_time:float = 5.0
var time_left: float
var max_time_value: float
var dragon_timer:Timer
var standard_bonus_time:float = 2.0

var currentGameState : gameState

enum gameState {
	home,
	combat,
	post_combat,
	shop,
}

# this single variable could hold the unlocks in the village
var unlocks: Dictionary = {}

# this is the resource you earn for upgrades and unlocks
var building_time:int

func _ready():
	create_dragon_timer()
	reset_time()
	dragon_timer.wait_time = time_left
	MapManager.entered_new_map.connect(add_dragon_time)
	UserInterface.update_progress_bar_max(max_time_value)
	UserInterface.update_time(dragon_timer.time_left)

func _physics_process(delta: float):
	if dragon_timer && !dragon_timer.paused:
		UserInterface.update_time(dragon_timer.time_left)

func start_dragon_timer():
	UserInterface.show()
	
	dragon_timer.paused = false
	dragon_timer.start(time_left)

func stop_dragon_timer():
	if !dragon_timer: return
	dragon_timer.paused = true
	if dragon_timer.time_left > 0.0:
		time_left = dragon_timer.time_left

func add_dragon_time(time:float = standard_bonus_time):
	time_left += time
	max_time_value += time
	UserInterface.update_progress_bar_max(max_time_value)

func create_dragon_timer():
	dragon_timer = Timer.new()
	add_child(dragon_timer)
	dragon_timer.timeout.connect(dragon_death)
	print("Dragon Timer created")

func dragon_death():
	stop_dragon_timer()
	reset_time()
	add_building_time(10)
	reset_game()

func reset_time():
	dragon_timer.wait_time = starting_time
	time_left = starting_time
	max_time_value = starting_time

func convert_flee_time(time:float) -> int:
	var days:int = roundi(time)%60
	return days
	#var weeks:int = days%7
	#days -= weeks * 7

func add_building_time(val:int):
	building_time += val
	print(building_time)

func reset_game():
	var loading_screen = preload("res://UserInterface/loading_screen.tscn").instantiate()
	get_tree().root.add_child(loading_screen)
	
	MapManager.reset()
	PlayerManager.reset()
	MusicManager.reset()
	
	await get_tree().create_timer(1.0).timeout
	UserInterface.hide()
	loading_screen.queue_free()
	MapManager.load_map()

func change_gamestate(new_gamestate:gameState):
	currentGameState = new_gamestate
