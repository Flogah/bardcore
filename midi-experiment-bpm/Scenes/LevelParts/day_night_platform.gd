@tool
extends StaticBody2D

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

@onready var visual: Node2D = %Visual
@onready var platform_color_shape: ColorRect = %PlatformColorShape
@onready var collision_shape_2d: CollisionShape2D = %CollisionShape2D

func _ready() -> void:
	Schnittstelle.day.connect(_on_change_to_day)
	Schnittstelle.night.connect(_on_change_to_night)

func _on_active_time_changed():
	platform_color_shape.color = cycle_colors[active_during]

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
	collision_shape_2d.disabled = true
	visual.modulate = Color(1, 1, 1, 0.2)

func wake():
	collision_shape_2d.disabled = false
	visual.modulate = Color(1, 1, 1, 1)
