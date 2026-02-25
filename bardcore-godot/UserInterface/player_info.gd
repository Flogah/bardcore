extends Control

const LIEBHABER_PORTRAIT_HOLZSCHNITT_2 = preload("uid://ds4ktephg6tuq")
const SAEUFER_PORTRAIT_HOLZSCHNITT_2 = preload("uid://vulycxh5qme7")
const GODOT_ICON = preload("uid://cbrmi5k31lw24")

var current_type: PlayerManager.bard_type

@onready var health_bar: ProgressBar = $ProgressBar
@onready var portrait: Sprite2D = $Control/Sprite2D

func set_type(type: PlayerManager.bard_type):
	current_type = type
	
	if type == PlayerManager.bard_type.lover:
		portrait.texture = LIEBHABER_PORTRAIT_HOLZSCHNITT_2
	elif type == PlayerManager.bard_type.relic:
		portrait.texture = SAEUFER_PORTRAIT_HOLZSCHNITT_2
	else:
		portrait.texture = GODOT_ICON

func update_health(new_value: float):
	health_bar.value = new_value

func set_max_health(new_value: float):
	health_bar.max_value = new_value
