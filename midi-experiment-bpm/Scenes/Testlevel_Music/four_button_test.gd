extends Control

signal achtel

var amy
var patch: int = 121
var starting_note: int = 60
var target_scale: String = "f-moll"
var notes = []
var achtel_count: int = 0

var tonart = 0
var pitch = 0
var note1 = 50
var note2 = 54
var note3 = 57
var note4 = 62

var waiting_note: Dictionary = {}
var capture_dict_1: Dictionary = {}

# --- BPM SYSTEM ---
var bpm: float = 120.0
var seconds_per_beat: float = 0.5
var seconds_per_achtel: float = 0.25

var beat_time: float = 0.0
var achtel_time: float = 0.0
var beats_per_bar: int = 4

# -------------------

@onready var button_1: Button = %Button1
@onready var button_2: Button = %Button2
@onready var button_3: Button = %Button3
@onready var button_4: Button = %Button4
@onready var metronome_audio_player_2d: AudioStreamPlayer2D = %MetronomeAudioPlayer2D
@onready var capture_toggle: Button = %CaptureToggle
@onready var time_label: Label = %TimeLabel
@onready var label_patch: Label = %LabelPatch
@onready var h_scroll_bar_patch: HScrollBar = %HScrollBarPatch

var capture_mode: bool = false
var time_signature: int = 0 # jetzt BEAT-basiert (0–3)

func _ready() -> void:
	label_patch.text = "Patch # " + str(patch)
	h_scroll_bar_patch.value = patch
	
	achtel.connect(play_note)
	notes = get_octave()
	
	update_bpm(bpm)
	
	amy = Amy.new()
	add_child(amy)
	await get_tree().process_frame
	
	button_1.button_down.connect(func(): queue_note_simple(1, 48, 0.8))
	button_1.button_up.connect(func(): queue_note_simple(1, 0, 0.0))
	button_2.button_down.connect(func(): queue_note_simple(2, 50, 0.8))
	button_2.button_up.connect(func(): queue_note_simple(2, 0, 0.0))
	button_3.button_down.connect(func(): queue_note_simple(3, 52, 0.8))
	button_3.button_up.connect(func(): queue_note_simple(3, 0, 0.0))
	button_4.button_down.connect(func(): queue_note_simple(4, 54, 0.8))
	button_4.button_up.connect(func(): queue_note_simple(4, 0, 0.0))
	
	capture_toggle.toggled.connect(capture_mode_activation)

func _process(delta: float) -> void:
	handle_bpm_input()
	handle_timing(delta)
	handle_input()
	
	if capture_mode:
		capture_toggle.text = str(beats_per_bar - time_signature)
	
	playback_from_capture()

# ------------------- BPM -------------------

func update_bpm(new_bpm: float):
	bpm = clamp(new_bpm, 20.0, 300.0)
	seconds_per_beat = 60.0 / bpm
	seconds_per_achtel = seconds_per_beat / 2.0

func increase_bpm(amount: float = 5.0):
	update_bpm(bpm + amount)

func decrease_bpm(amount: float = 5.0):
	update_bpm(bpm - amount)

func handle_bpm_input():
	if Input.is_action_just_pressed("bpm_up"):
		increase_bpm()
	if Input.is_action_just_pressed("bpm_down"):
		decrease_bpm()

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
		
		if time_signature >= beats_per_bar:
			time_signature = 0
			achtel_count = 0
			metronome_tick()
	
	time_label.text = "BPM: " + str(int(bpm)) + " | Beat: " + str(time_signature)

# ------------------- INPUT -------------------

func handle_input():
	var l_stick_input = Input.get_vector("l_stick_left", "l_stick_right", "l_stick_down", "l_stick_up")
	joystick_input_mapping(l_stick_input)
	
	if Input.is_action_just_pressed("capture_mode"):
		capture_mode_activation(true)
	if Input.is_action_just_released("capture_mode"):
		capture_mode_activation(false)

func joystick_input_mapping(input: Vector2):
	if Input.is_action_just_pressed("l_stick_down"):
		queue_note_simple(1,note3+pitch,1.0)
	if Input.is_action_just_pressed("l_stick_up"):
		queue_note_simple(1,note1+pitch,1.0)
	if Input.is_action_just_pressed("l_stick_right"):
		queue_note_simple(1,note2+pitch+tonart,1.0)
	if Input.is_action_just_pressed("l_stick_left"):
		queue_note_simple(1,note4+pitch,1.0)
	if Input.is_action_just_pressed("pitch_up"):
		pitch += 1
	if Input.is_action_just_pressed("pitch_down"):
		pitch -= 1
	if Input.is_action_just_pressed("change_tonart"):
		if tonart == -1:
			set_tonart(true)
		else: 
			set_tonart(false)

# ------------------- NOTE SYSTEM -------------------

func queue_note_simple(synth: int = 1, note: int = 52, vel: float = 1.0):
	var data = {
		"synth" : synth,
		"note" : note,
		"vel" : vel,
		"kind" : tonart
	}
	queue_note(data)

func queue_note(data: Dictionary):
	var synth = data["synth"]
	var note = data["note"]
	var vel = data["vel"]
	var kind = data["kind"]
	
	waiting_note = {"synth": synth, "patch": patch, "note": note, "vel": vel, "kind": kind}
	
	if capture_mode:
		capture_note(data)

func play_note():
	if waiting_note.size() > 0:
		amy.send({"synth": waiting_note["synth"], "patch": waiting_note["patch"], "num_voices": 6, "note": waiting_note["note"] + waiting_note["kind"], "vel": waiting_note["vel"]})
		Schnittstelle.add_note(waiting_note["note"], waiting_note["kind"])
		waiting_note = {}

# ------------------- CAPTURE -------------------

func capture_note(data: Dictionary):
	data["synth"] = 2
	
	var key = str(time_signature) + "_" + str(achtel_count % 8)
	capture_dict_1[key] = data

func playback_from_capture():
	var key = str(time_signature) + "_" + str(achtel_count % 8)
	
	if capture_dict_1.has(key):
		queue_note(capture_dict_1[key])

func capture_mode_activation(toggle):
	if toggle:
		capture_dict_1 = {}
		capture_mode = true
	else:
		capture_toggle.text = "CAPTURE"
		capture_toggle.disabled = false
		capture_mode = false

# ------------------- MISC -------------------

func metronome_tick():
	metronome_audio_player_2d.play()

func _on_h_scroll_bar_patch_value_changed(value: float) -> void:
	patch = value
	label_patch.text = "Patch # " + str(patch)

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
	return new_array

func set_tonart(dur: bool) -> void:
	if dur:
		tonart = 0
	else:
		tonart = -1
