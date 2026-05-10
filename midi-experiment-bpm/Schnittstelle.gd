extends Node

signal up
signal down
signal fire
signal water
signal day
signal night

var notes_played: Array = [0,0,0,0,0]
var tonart: int = 0

func add_note(note: int) -> void:
	notes_played.push_front(note)
	if notes_played.size() > 5:
		notes_played = notes_played.slice(0,4)
	check_for_triggers()

func check_for_triggers() -> void:
	check_up_or_down()
	check_fire_or_water()
	check_night_or_day()

func check_up_or_down() -> void:
	var difference: int = notes_played[0] - notes_played[1]
	if difference > 0:
		up.emit()
	elif difference < 0:
		down.emit()
	print(difference)

func check_fire_or_water() -> void:
	if notes_played[0] == notes_played[2] && notes_played[1] == notes_played[3]:
		fire.emit()
	elif notes_played[0] == notes_played[1] && notes_played[1] == notes_played[2] && notes_played[2] == notes_played[3]:
		water.emit()

func check_night_or_day() -> void:
	if tonart == 0:
		day.emit()
	if tonart == -1:
		night.emit()
