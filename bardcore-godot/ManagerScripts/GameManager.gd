extends Node

# get's carried from map to map, so it's important to not have it be a single timer node
var time_left: float = 30.0
var max_time_value: float
var dragon_timer:Timer
var is_running:bool
# this single variable could hold the unlocks in the village
var unlocks: Dictionary = {}

func _physics_process(delta: float) -> void:
	if is_running:
		UserInterface.update_label(snapped(dragon_timer.time_left, 0.1))
		UserInterface.update_prograss_bar(dragon_timer.time_left, time_left)

func start_dragon_timer() -> void:
	if !dragon_timer:
		create_dragon_timer()
	UserInterface.show()
	dragon_timer.paused = false
	dragon_timer.start(time_left)
	is_running = true

func stop_dragon_timer() -> void:
	if !dragon_timer: return
	is_running = false
	dragon_timer.paused = true
	time_left = dragon_timer.time_left

func dragon_death() -> void:
	is_running = false
	get_tree().paused = true

func create_dragon_timer()->void:
	dragon_timer = Timer.new()
	add_child(dragon_timer)
	dragon_timer.timeout.connect(dragon_death)
	print("Dragon Timer created")
