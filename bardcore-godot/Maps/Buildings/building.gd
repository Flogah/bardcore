class_name Building
extends Interactable

signal building_upgraded

enum buildState {
	unbuilt,
	level1,
	level2,
	level3,
}

@export var building_name:String

@export var state:buildState = buildState.unbuilt

@export var building_levels: Dictionary[buildState, Node3D] = {
	buildState.unbuilt: null,
	buildState.level1: null,
	buildState.level2: null,
	buildState.level3: null,
}

# this defines the cost for upgrade from the stated state
# if it's not in this list, you can' upgrade
@export var build_cost: Dictionary[buildState, int] = {
	buildState.unbuilt: 1,
	buildState.level1: 3,
	buildState.level2: 5,
}

@export var upgrade_list: Dictionary[buildState, upgrade] = {
	buildState.unbuilt: null,
	buildState.level1: null,
	buildState.level2: null,
	buildState.level3: null,
}

#@export var build_level_models:Dictionary[buildState, Node3D] = {}

@onready var collision: CollisionShape3D = $Collision/CollisionShape3D
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var interaction_collision: CollisionShape3D = $CollisionShape3D

func interact():
	upgrade_to(state +1)

func upgrade_to(target_level: buildState):
	# does the current build state even have an upgrade cost
	if !build_cost.has(state): return
	# this applies the cost but already checks if there is enough balance left
	if !GameManager.pay_building_cost(build_cost.get(state)): return
	var new_model = building_levels[target_level]
	if !new_model: return
	var curr_model = building_levels[state]
	
	state = target_level
	building_upgraded.emit()
	PlayerManager.apply_village_upgrades()
	
	interaction_collision.disabled = true
	collision.disabled = true
	new_model.position.y = -13.0
	
	var building_anim_tween = create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS).set_parallel(true)
	building_anim_tween.tween_property(curr_model, "position:y", -13.0, 1.0)
	curr_model.hide()
	
	new_model.show()
	building_anim_tween.tween_property(new_model, "position:y", 0.0, 1.0)
	
	collision.disabled = false
	interaction_collision.disabled = false

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
	if hint: hint.queue_free()
	#UserInterface.hide_upgrade_hint()
	
func display_hint() -> void:
	if hint: return
	
	var upgrade_available:bool = false
	var upgrade_txt = "{0} lv.{1}".format([building_name, state])
	if upgrade_list[state]:
		upgrade_txt += "\n Current effect: {0}".format([upgrade_list[state].explanation])
	if get_current_upgrade_cost() > -1:
		if get_current_upgrade_cost() == 1:
			upgrade_txt +=  "\n Kosten: {0} Tag".format([get_current_upgrade_cost()])
		else:
			upgrade_txt +=  "\n Kosten: {0} Tage".format([get_current_upgrade_cost()])
		upgrade_available = true
	if state+1 in upgrade_list.keys():
		if upgrade_list[state+1]:
			upgrade_txt += "\n Next effect: {0}".format([upgrade_list[state+1].explanation])
	hint = UserInterface.create_hint(global_position, upgrade_txt, upgrade_available)

func remove_hint() -> void:
	if hint: hint.queue_free()
	
func get_current_upgrade_cost() -> int:
	if !build_cost.has(state):
		return -1
	return build_cost.get(state)

func set_state(new_state: int):
	for level in building_levels:
		building_levels[level].hide()
	
	building_levels[new_state].show()
	
	state = new_state as buildState

func get_current_upgrade() -> upgrade:
	return upgrade_list[state]

func reveal():
	show()
	interaction_collision.disabled = false
