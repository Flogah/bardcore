extends Node2D

var day: bool = false

@onready var stage_day: Sprite2D = $EnvironmentTag
@onready var stage_night: Sprite2D = $EnvironmentNacht

func _ready() -> void:
	Schnittstelle.day.connect(switch_day_night.bind(true))
	Schnittstelle.night.connect(switch_day_night.bind(false))

func switch_day_night(day: bool) -> void:
	stage_day.visible = day
	stage_night.visible = !day
