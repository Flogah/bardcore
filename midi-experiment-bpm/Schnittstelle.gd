extends Node

signal up
signal down
signal fire
signal water

var notes_played: Array = []

func add_note(note: int) -> void:
	notes_played.push_front(note)
	if notes_played.size() > 4:
		notes_played = notes_played.slice(0,3)
	check_for_triggers()

func check_for_triggers() -> void:
	check_up_or_down()
	check_fire_or_water()

func check_up_or_down() -> void:
	var difference: int = notes_played[0] - notes_played[1]
	if difference > 0:
		up.emit()
	elif difference < 0:
		down.emit()

func check_fire_or_water() -> void:
	if notes_played[0] == notes_played[2] && notes_played[1] == notes_played[3]:
		fire.emit()
	elif notes_played[0] == notes_played[1] == notes_played[2] == notes_played[3]:
		water.emit()
