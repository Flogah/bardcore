class_name Building extends Node3D

enum buildState {
	unbuilt,
	level1,
	level2,
}

@export var state:buildState = buildState.unbuilt

# this defines the cost for upgrade from the stated state
# if it's not in this list, you can' upgrade
@export var build_cost: Dictionary[buildState, int] = {
	buildState.unbuilt: 1,
	buildState.level1: 2,
}

@export var level_0: Node3D
@export var level_1: Node3D
@export var level_2: Node3D
@export var level_3: Node3D
@export var level_4: Node3D

@onready var collision: CollisionShape3D = $Collision/CollisionShape3D

func interact():
	upgrade()

func upgrade():
	# does the current build state even have an upgrade cost
	if !build_cost.has(state):
		return
	# this applies the cost but already checks if there is enough balance left
	if !GameManager.pay_building_cost(build_cost.get(state)):
		return
	if state == buildState.unbuilt:
		build_to_1()
	elif state == buildState.level1:
		build_to_2()

#region Upgrade Behaviour
func build_to_1():
	# upgrade anim
	level_0.hide()
	level_1.show()
	state = buildState.level1
	
	collision.disabled = false

func build_to_2():
	# build anim
	level_1.hide()
	level_2.show()
	state = buildState.level2
#endregion

func _on_interaction_area_body_entered(body: Node3D) -> void:
	body.interact.connect(interact)

func _on_interaction_area_body_exited(body: Node3D) -> void:
	if body.interact.is_connected(interact):
		body.interact.disconnect(interact)
