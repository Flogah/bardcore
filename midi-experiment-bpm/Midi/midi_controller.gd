class_name MidiController
extends Node

signal beat
signal achtel
signal scale_changed(new_scale)
signal bpm_changed(new_bpm)
signal note_played(note_value)
signal capture_mode_changed(new_mode)
signal tonart_changed(new_tonart)

var amy
var patch: int = 13
var starting_note: int = 60
var target_scale: String = "f-moll"
var notes = []
var achtel_count: int = 0

var tonart = 0
var pitch = 0
var note1 = 31
var note2 = 36
var note3 = 41
var note4 = 45
var note5 = 50

var last_played_note: int = 0
var waiting_note: Dictionary = {}
var capture_dict_1: Dictionary = {}
var note_queue:Dictionary[float, Dictionary] = {}

# --- BPM SYSTEM ---
var bpm: float = 120.0
var seconds_per_beat: float = 0.5
var seconds_per_achtel: float = 0.25

var beat_time: float = 0.0
var achtel_time: float = 0.0
var beats_per_bar: int = 4

# -------------------

var input_allowed: bool = true
var debug_mode: bool = true
var capture_mode: bool = false
var time_signature: int = 0 # jetzt BEAT-basiert (0–3)

# --- DEBUG UI
@onready var input_allowed_label: Label = %InputAllowedLabel
@onready var bpm_label: Label = %BPMLabel
@onready var time_to_beat_label: Label = %TimeToBeatLabel
@onready var bar_label: Label = %BarLabel
@onready var note_label: Label = %NoteLabel

func _ready() -> void:
	init_amy()
	achtel.connect(play_note)
	notes = get_octave()
	
	update_bpm(bpm)

func _process(delta: float) -> void:
	handle_timing(delta)
	handle_input()
	
	#playback_from_capture()
	read_note_queue(delta)
	
	if debug_mode:
		update_debug_ui()

func init_amy():
	amy = Amy.new()
	add_child(amy)
	await get_tree().process_frame

# ------------------- BPM -------------------

func update_bpm(new_bpm: float):
	var old_bpm = bpm
	bpm = clamp(new_bpm, 20.0, 300.0)
	if bpm != old_bpm:
		bpm_changed.emit(bpm)
	seconds_per_beat = 60.0 / bpm
	seconds_per_achtel = seconds_per_beat / 2.0

func increase_bpm(amount: float = 5.0):
	update_bpm(bpm + amount)

func decrease_bpm(amount: float = 5.0):
	update_bpm(bpm - amount)

# ------------------- TIMING -------------------

func handle_timing(delta: float):
	beat_time += delta
	achtel_time += delta
	
	# Achtel
	if achtel_time >= seconds_per_achtel:
		achtel_time -= seconds_per_achtel
		achtel_count += 1
		achtel.emit()
	
	# Beat
	if beat_time >= seconds_per_beat:
		beat_time -= seconds_per_beat
		time_signature += 1
		beat.emit()
		
		if time_signature >= beats_per_bar:
			time_signature = 0
			achtel_count = 0

# ------------------- INPUT -------------------

func handle_input():
	if Input.is_action_just_pressed("bpm_up"):
		increase_bpm()
	if Input.is_action_just_pressed("bpm_down"):
		decrease_bpm()
	
	if Input.is_action_just_pressed("pick_1"):
		queue_note(pack_note(1,note1+pitch))
	if Input.is_action_just_pressed("pick_2"):
		queue_note(pack_note(2,note2+pitch))
	if Input.is_action_just_pressed("pick_3"):
		queue_note(pack_note(3,note3+pitch))
	if Input.is_action_just_pressed("pick_4"):
		queue_note(pack_note(4,note4+pitch))
	if Input.is_action_just_pressed("pick_5"):
		queue_note(pack_note(5,note5+pitch))
	
	if Input.is_action_just_pressed("strum_up"):
		strum_up()
	if Input.is_action_just_pressed("strum_down"):
		strum_down()
	
	if Input.is_action_just_pressed("change_tonart"):
		if tonart == 0:
			set_tonart(false)
		else:
			set_tonart(true)
	
	if Input.is_action_just_pressed("capture_mode"):
		capture_mode_activation(true)
	if Input.is_action_just_released("capture_mode"):
		capture_mode_activation(false)


# ------------------- NOTE SYSTEM -------------------

func pack_note(synth: int = 1, note: int = 52, vel: float = 1.0) -> Dictionary:
	var data = {
		"synth" : synth,
		"note" : note,
		"vel" : vel,
		"kind" : tonart
	}
	return data

func queue_note(data: Dictionary, delay:float = 0.0):
	var synth = data["synth"]
	var note = data["note"]
	var vel = data["vel"]
	var kind = data["kind"]
	
	note_queue[delay] = {"synth": synth, "patch": patch, "num_voices": 6, "note": note, "vel": vel, "kind": kind}
	
	if capture_mode:
		capture_note(data)

func read_note_queue(delta):
	var keys = note_queue.keys()
	for timing in keys:
		var data = note_queue[timing]
		note_queue.erase(timing)
		var new_timing = timing
		new_timing -= delta
		if new_timing <= 0.0:
			play_note_direct(data)
		else:
			note_queue[new_timing] = data

func play_note():
	if waiting_note.size() > 0:
		amy.send({"synth": waiting_note["synth"], "patch": waiting_note["patch"], "num_voices": 6, "note": waiting_note["note"] + waiting_note["kind"], "vel": waiting_note["vel"]})
		Schnittstelle.add_note(waiting_note["note"], waiting_note["kind"])
		last_played_note = waiting_note["note"]
		note_played.emit(waiting_note["note"])
		waiting_note = {}

func play_note_direct(data: Dictionary):
	var synth = data["synth"]
	var note = data["note"]
	var vel = data["vel"]
	var kind = data["kind"]
	
	amy.send({"synth": synth, "patch": patch, "num_voices": 6, "note": note + kind, "vel": vel})
	Schnittstelle.add_note(note, kind)
	note_played.emit(note)

func strum_up(strum_delay:float = 0.07):
	queue_note(pack_note(1, note1+pitch), strum_delay * 0)
	queue_note(pack_note(2, note2+pitch), strum_delay * 1)
	queue_note(pack_note(3, note3+pitch), strum_delay * 2)
	queue_note(pack_note(4, note4+pitch), strum_delay * 3)
	queue_note(pack_note(5, note5+pitch), strum_delay * 4)

func strum_down(strum_delay:float = 0.07):
	queue_note(pack_note(1, note5+pitch), strum_delay * 0)
	queue_note(pack_note(2, note4+pitch), strum_delay * 1)
	queue_note(pack_note(3, note3+pitch), strum_delay * 2)
	queue_note(pack_note(4, note2+pitch), strum_delay * 3)
	queue_note(pack_note(5, note1+pitch), strum_delay * 4)

# ------------------- CAPTURE -------------------

func capture_note(data: Dictionary):
	data["synth"] = 2
	
	var key = str(time_signature) + "_" + str(achtel_count % 8)
	capture_dict_1[key] = data

func playback_from_capture():
	var key = str(time_signature) + "_" + str(achtel_count % 8)
	
	#if capture_dict_1.has(key):
		#queue_note(capture_dict_1[key])

func capture_mode_activation(toggle):
	if toggle:
		capture_dict_1 = {}
		capture_mode = true
	else:
		capture_mode = false
	capture_mode_changed.emit(capture_mode)

# ------------------- MISC -------------------

func get_octave(start_note: int = starting_note) -> Array:
	return [
		0,
		start_note,
		start_note +2,
		start_note +4,
		start_note +8,
		start_note +10,
		start_note +12,
		start_note +14,
		start_note +16,
	]

func apply_scale(note_array: Array, scale: String) -> Array:
	var new_array = note_array
	match scale:
		"d-moll":
			for note in note_array:
				if note % 12 == 11:
					note -= 1
			new_array = note_array.map(func(n): return n + 2)
		"f-moll":
			for note in note_array:
				var r = note % 12
				if r == 4 or r == 9 or r == 11:
					note -= 1
			new_array = note_array.map(func(n): return n + 5)
		"test":
			pass
	scale_changed.emit(scale)
	return new_array

func set_tonart(dur: bool) -> void:
	if dur:
		tonart = 0
		tonart_changed.emit("dur")
	else:
		tonart = -1
		tonart_changed.emit("moll")

func get_note_name(note: int) -> String:
	var note_name: String = "NaN"
	var remain: int = note % 12
	match remain:
		0: note_name = "C"
		1: note_name = "C#"	
		2: note_name = "D"
		3: note_name = "D#"
		4: note_name = "E"
		5: note_name = "F"
		6: note_name = "F#"
		7: note_name = "G"
		8: note_name = "G#"
		9: note_name = "A"
		10: note_name = "A#"
		11: note_name = "H"
	note_name += str(note/12)
	
	return note_name

# --- DEBUG

func update_debug_ui():
	input_allowed_label.text = "input_allowed: " + str(input_allowed)
	bpm_label.text = "bpm: " + str(snapped(bpm, 0.1))
	time_to_beat_label.text = "beat_time: " + str(snapped(beat_time, 0.01)) + " / " + str(snapped(seconds_per_beat, 0.01))
	bar_label.text = "bar: " + str(time_signature + 1) + " / " + str(beats_per_bar)
	note_label.text = "note: " + get_note_name(last_played_note)
