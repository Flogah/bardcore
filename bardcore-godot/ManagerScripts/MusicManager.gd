extends Node

@export var current_music: AudioStreamPlayer
var music_player_1: AudioStreamPlayer
var music_player_2: AudioStreamPlayer
var beatTimer: Timer
var music_volume = -20
var music1 = preload("uid://cgp353opwrx4t")
var music2 = preload("uid://dc23co36v6bdl")
@export var rhythm_notifier: RhythmNotifier
signal beat
signal halfBeat
signal quarterBeat
signal eighthBeat

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_music_player()
	setup_music()
	setup_rhythm()
	setup_timer()
	beats()
	half_beat()
	quarter_beat()
	eighth_beat()
	play_music()

func setup_music() -> void:
	current_music = AudioStreamPlayer.new()
	add_child(current_music)
	current_music.set_autoplay(true)
	current_music.volume_db = music_volume
	current_music = music_player_1

func change_music(from: AudioStreamPlayer, to: AudioStreamPlayer, bpm: int = 100) -> void:
	stop_music()
	if current_music == from:
		current_music = to
	change_rhythm(bpm)
	play_music()

func play_music() -> void:
	current_music.play()

func stop_music() -> void:
	current_music.stop()

func setup_rhythm() -> void:
	rhythm_notifier = RhythmNotifier.new()
	add_child(rhythm_notifier)
	rhythm_notifier.bpm = 120
	rhythm_notifier.audio_stream_player = current_music

func change_rhythm(bpm: int) -> void:
	rhythm_notifier.bpm = bpm
	rhythm_notifier.audio_stream_player = current_music

func setup_timer() -> void:
	beatTimer = Timer.new()
	add_child(beatTimer)
	beatTimer.start(3.0)

func setup_music_player() -> void:
	music_player_1 = AudioStreamPlayer.new()
	music_player_2 = AudioStreamPlayer.new()
	add_child(music_player_1)
	add_child(music_player_2)
	music_player_1.set_stream(music1)
	music_player_2.set_stream(music2)


func beats() -> void:
	rhythm_notifier.beats(1).connect(func(count):
		#print("BEAT")
		beat.emit())
		
func half_beat() -> void:
	rhythm_notifier.beats(2).connect(func(count):
		#print("BEAT")
		halfBeat.emit())
		
func quarter_beat() -> void:
	rhythm_notifier.beats(4).connect(func(count):
		#print("BEAT")
		quarterBeat.emit())
		
func eighth_beat() -> void:
	rhythm_notifier.beats(8).connect(func(count):
		#print("BEAT")
		eighthBeat.emit())
	#emit_signal(notify_signal)
	
func reset():
	# TODO reset everything so the music restarts clean
	pass
