class_name Building
extends Interactable

signal building_upgraded
signal left_hint_area

enum buildState {
	unbuilt,
	level1,
	level2,
	level3,
}

@export var building_name:String

@export var state:buildState = buildState.unbuilt

# this defines the cost for upgrade from the stated state
# if it's not in this list, you can' upgrade
@export var build_cost: Dictionary[buildState, int] = {
	buildState.unbuilt: 1,
	buildState.level1: 3,
	buildState.level2: 5,
}

@export var level_0: Node3D
@export var level_1: Node3D
@export var level_2: Node3D
@export var level_3: Node3D
@export var level_4: Node3D

var hint
#@export var build_level_models:Dictionary[buildState, Node3D] = {}

@onready var collision: CollisionShape3D = $Collision/CollisionShape3D
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var interaction_collision: CollisionShape3D = $InteractionArea/CollisionShape3D

func interact():
	upgrade()

func upgrade():
	# does the current build state even have an upgrade cost
	if !build_cost.has(state):
		return
	# this applies the cost but already checks if there is enough balance left
	if !GameManager.pay_building_cost(build_cost.get(state)):
		return
	
	interaction_collision.disabled = true
	if state == buildState.unbuilt:
		build_to_1()
	elif state == buildState.level1:
		build_to_2()
	elif state == buildState.level2:
		build_to_3()

#region Upgrade Behaviour
# could be more compact, but allows less control
#func build_up(new_state:buildState = state + 1):
	#if build_level_models.has(new_state):
		#print(build_level_models.get(new_state))

func build_to_1():
	# upgrade anim
	anim.animation_finished.connect(finish_building_1)
	level_1.show()
	anim.play("level0_to_level1")

func finish_building_1(_anim):
	anim.animation_finished.disconnect(finish_building_1)
	level_0.hide()
	state = buildState.level1
	building_upgraded.emit()
	
	collision.disabled = false
	interaction_collision.disabled = false

func build_to_2():
	# build anim
	level_2.show()
	anim.animation_finished.connect(finish_building_2)
	anim.play("level1_to_level2")

func finish_building_2(_anim):
	anim.animation_finished.disconnect(finish_building_2)
	level_1.hide()
	state = buildState.level2
	building_upgraded.emit()
	
	interaction_collision.disabled = false

func build_to_3():
	# build anim
	level_3.show()
	anim.animation_finished.connect(finish_building_3)
	anim.play("level2_to_level3")

func finish_building_3(_anim):
	anim.animation_finished.disconnect(finish_building_3)
	level_2.hide()
	state = buildState.level3
	building_upgraded.emit()
	
	interaction_collision.disabled = false
#endregion

func _on_interaction_area_area_entered(_area: Area3D) -> void:
	if hint: return
	
	var upgrade_available:bool = false
	var upgrade_txt = "{0} lv.{1}".format([building_name, state])
	if get_current_upgrade_cost() > -1:
		if get_current_upgrade_cost() == 1:
			upgrade_txt +=  "\n Kosten: {0} Tag".format([get_current_upgrade_cost()])
		else:
			upgrade_txt +=  "\n Kosten: {0} Tage".format([get_current_upgrade_cost()])
		upgrade_available = true
	hint = UserInterface.create_hint(global_position, upgrade_txt, upgrade_available)
	#UserInterface.show_upgrade_hint(self)

func _on_interaction_area_area_exited(_area: Area3D) -> void:
	hint.queue_free()
	#UserInterface.hide_upgrade_hint()

func get_current_upgrade_cost() -> int:
	if !build_cost.has(state):
		return -1
	return build_cost.get(state)

func set_state(new_state: int):
	level_0.hide()
	level_1.hide()
	level_2.hide()
	level_3.hide()
	level_4.hide()
	
	if new_state == 0:
		level_0.show()
	if new_state == 1:
		level_1.show()
	if new_state == 2:
		level_2.show()
	if new_state == 3:
		level_3.show()
	if new_state == 4:
		level_4.show()
	
	state = new_state as buildState
