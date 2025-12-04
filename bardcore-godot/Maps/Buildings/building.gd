class_name Building extends Node3D

enum buildState {
	unbuilt,
	level1,
	level2,
}

@export var state:buildState = buildState.unbuilt

@export var build_cost: Dictionary[buildState, int] = {
	buildState.unbuilt: 1,
	buildState.level1: 4,
}

@onready var level_0: Node3D = $Level0
@onready var level_1: Node3D = $Level1
@onready var level_2: Node3D = $Level2

func interact():
	upgrade()

func upgrade():
	# this applies the cost but already checks if there is enough balance left
	if !GameManager.pay_building_cost(build_cost.get(state)):
		return
	if state == buildState.unbuilt:
		# build anim
		build_to_1()
		state = buildState.level1
	elif state == buildState.level1:
		# upgrade anim
		build_to_2()
		state = buildState.level2

func build_to_1():
	level_0.hide()
	level_1.show()

func build_to_2():
	level_1.hide()
	level_2.show()

func _on_interaction_area_body_entered(body: Node3D) -> void:
	body.interact.connect(interact)

func _on_interaction_area_body_exited(body: Node3D) -> void:
	if body.interact.is_connected(interact):
		body.interact.disconnect(interact)
