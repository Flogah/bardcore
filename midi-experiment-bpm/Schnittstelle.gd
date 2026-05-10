extends Node

signal up
signal down
signal fire
signal water
signal day
signal night

var notes_played: Array = [{"note": 0, "kind": 0},{"note": 0, "kind": 0},{"note": 0, "kind": 0},{"note": 0, "kind": 0},]

func add_note(note: int, kind: int) -> void:
	notes_played.push_front({"note": note, "kind": kind})
	if notes_played.size() > 5:
		notes_played = notes_played.slice(0,4)
	check_for_triggers()

func check_for_triggers() -> void:
	check_up_or_down()
	check_fire_or_water()
	check_night_or_day()

func check_up_or_down() -> void:
	var difference: int = notes_played[0]["note"] - notes_played[1]["note"]
	if difference > 0:
		up.emit()
	elif difference < 0:
		down.emit()
	print(difference)

func check_fire_or_water() -> void:
	if notes_played[0]["note"] == notes_played[2]["note"] && notes_played[1]["note"] == notes_played[3]["note"]:
		fire.emit()
	elif notes_played[0]["note"] == notes_played[1]["note"] && notes_played[1]["note"] == notes_played[2]["note"] && notes_played[2]["note"] == notes_played[3]["note"]:
		water.emit()

func check_night_or_day() -> void:
	if notes_played[0]["kind"] == 0:
		day.emit()
	if notes_played[0]["kind"] == -1:
		night.emit()
