extends Node

var music_list: Array
@export var current_music: AudioStreamPlayer
var beatTimer: Timer
var music_volume = -20
var music1 = preload("uid://cgp353opwrx4t")
@onready var rhythm_notifier: RhythmNotifier = $RhythmNotifier
signal beat

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_music()
	setup_rhythm()
	setup_timer()
	rhythm_signal(2)
	play_music()

func change_music(index) -> void:
	current_music = index
	#play_music("Music")

func play_music(from_position: float = 0.0) -> void:
	current_music.play(from_position)

func setup_rhythm() -> void:
	rhythm_notifier = RhythmNotifier.new()
	add_child(rhythm_notifier)
	rhythm_notifier.bpm = 120
	rhythm_notifier.audio_stream_player = current_music

func setup_timer() -> void:
	beatTimer = Timer.new()
	add_child(beatTimer)
	beatTimer.start(3.0)

func setup_music() -> void:
	current_music = AudioStreamPlayer.new()
	add_child(current_music)
	current_music.set_stream(music1)
	current_music.volume_db = music_volume

func rhythm_signal(every_beat: int) -> void:
	rhythm_notifier.beats(every_beat).connect(func(count):
		print("BEAT")
		beat.emit())
	#emit_signal(notify_signal)
	
	
