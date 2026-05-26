@tool
extends Node

enum cycle {
	day,
	night
}

@export var active_during: cycle:
	set(new_time):
		active_during = new_time
		_on_active_time_changed()

@export var cycle_colors: Dictionary[cycle, Color] = {
	cycle.day: Color.ORANGE_RED,
	cycle.night: Color.MEDIUM_PURPLE
}

@onready var platform: AnimatableBody2D = get_parent()
var collision: CollisionShape2D

func _ready() -> void:
	Schnittstelle.day.connect(_on_change_to_day)
	Schnittstelle.night.connect(_on_change_to_night)
	
	for child in platform.get_children():
		if child is CollisionShape2D:
			collision = child
			continue
	if !platform:
		printerr("No CollisionShape3D in Platform")
	else:
		if Schnittstelle.is_day:
			_on_change_to_day()
		else:
			_on_change_to_night()

func _on_active_time_changed():
	if platform:
		platform.modulate = cycle_colors[active_during]

func _on_change_to_night():
	if active_during == cycle.night:
		wake()
	else:
		sleep()

func _on_change_to_day():
	if active_during == cycle.day:
		wake()
	else:
		sleep()

func day_night_change(new_time: cycle):
	if new_time == active_during:
		wake()
	else:
		sleep()

func sleep():
	collision.disabled = true
	platform.modulate = Color(1, 1, 1, 0.2)

func wake():
	collision.disabled = false
	platform.modulate = Color(1, 1, 1, 1)
