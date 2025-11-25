extends Node

# get's carried from map to map, so it's important to not have it be a single timer node
var time_left: float = 30.0
var max_time_value: float
var dragon_timer:Timer
var is_running:bool

# maybe different states to start out?

# this single variable could hold the unlocks in the village
var unlocks: Dictionary = {}

func _physics_process(delta: float):
	if is_running:
		UserInterface.update_time(dragon_timer.time_left)

func start_dragon_timer():
	if !dragon_timer:
		create_dragon_timer()
	UserInterface.show()
	UserInterface.update_progress_bar_max(max_time_value)
	dragon_timer.paused = false
	dragon_timer.start(time_left)
	is_running = true

func stop_dragon_timer():
	if !dragon_timer: return
	is_running = false
	dragon_timer.paused = true
	time_left = dragon_timer.time_left

func add_dragon_time(time:float):
	time_left += time
	max_time_value += time

func dragon_death():
	is_running = false
	get_tree().paused = true

func create_dragon_timer():
	dragon_timer = Timer.new()
	add_child(dragon_timer)
	dragon_timer.timeout.connect(dragon_death)
	max_time_value = time_left
	print("Dragon Timer created")
