extends Node2D

@onready var night: Sprite2D = $Night
@onready var day: Sprite2D = $Day
@onready var moon: Sprite2D = $Moon
@onready var sun: Sprite2D = $Sun

func _ready() -> void:
	Schnittstelle.day.connect(_on_day)
	Schnittstelle.night.connect(_on_night)
	if Schnittstelle.is_day:
		_on_day()
	else: _on_night()

func _on_day() -> void:
	night.visible = false
	moon.visible = false
	day.visible = true
	sun.visible = true

func _on_night() -> void:
	night.visible = true
	moon.visible = true
	day.visible = false
	sun.visible = false
