extends Node
class_name StateMachine

@export var initial_state : State

var states: Dictionary = {}

@onready var state: State = (func get_initial_state() -> State:
	return initial_state if initial_state != null else get_child(0)).call()

func _ready() -> void:
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.finished.connect(_transition_to_next_state)
	await owner.ready
	state.enter("")

func _unhandled_input(event: InputEvent) -> void:
	state.handle_input(event)

func _process(delta: float) -> void:
	state.update(delta)

func _physics_process(delta: float) -> void:
	state.physics_update(delta)

func _transition_to_next_state(target_state_path:String, data: Dictionary = {}) -> void:
	if !has_node(target_state_path):
		printerr(owner.name + ": Trying to transition to state " + target_state_path + " but it does not exist.")
		return
	var previous_state_path: String = state.name
	state.exit()
	state = get_node(target_state_path)
	state.enter(previous_state_path, data)
	print(state.name)
