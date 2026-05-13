extends Node2D

var day: bool = false

@onready var stage_day: Sprite2D = $EnvironmentTag
@onready var stage_night: Sprite2D = $EnvironmentNacht
@onready var ui_day: Sprite2D = $MusikbarTag
@onready var ui_night: Sprite2D = $MusikbarNacht

var game_over:bool = false

@export var end_portal:EndPortal
@export var game_over_ui:CanvasLayer

func _ready() -> void:
	Schnittstelle.day.connect(switch_day_night.bind(true))
	Schnittstelle.night.connect(switch_day_night.bind(false))
	end_portal.end_reached.connect(_on_game_over_reached)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("reset"):
		manual_reset()

func _on_game_over_reached():
	game_over = true
	game_over_ui.show()
	get_tree().paused = true

func manual_reset():
	get_tree().reload_current_scene()



func switch_day_night(day: bool) -> void:
	stage_day.visible = day
	ui_day.visible = day
	stage_night.visible = !day
	ui_night.visible = !day
