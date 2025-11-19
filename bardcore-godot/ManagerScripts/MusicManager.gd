extends Node

var music_list: AudioStreamInteractive
@export var current_music: AudioStream
var current_music_player: AudioStreamPlayer
var beatTimer: Timer
var music_volume = -20
var music1 = preload("uid://cgp353opwrx4t")
var music2 = preload("uid://dc23co36v6bdl")
@export var rhythm_notifier: RhythmNotifier
signal beat

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_music_playlist()
	
	setup_music_player(current_music)
	setup_music(0)
	setup_rhythm()
	setup_timer()
	rhythm_signal(2)
	play_music()

func setup_music(index: int) -> void:
	current_music = AudioStream.new()
	current_music = music_list.get_clip_stream(index)

func change_music(index: int) -> void:
	music_list.switch_to_clip(index)

func play_music(from_position: float = 0.0) -> void:
	current_music_player.play(from_position)

func setup_rhythm() -> void:
	rhythm_notifier = RhythmNotifier.new()
	add_child(rhythm_notifier)
	rhythm_notifier.bpm = 120
	rhythm_notifier.audio_stream_player = current_music_player

func setup_timer() -> void:
	beatTimer = Timer.new()
	add_child(beatTimer)
	beatTimer.start(3.0)

func setup_music_player(current_music: AudioStream) -> void:
	current_music_player = AudioStreamPlayer.new()
	add_child(current_music_player)
	current_music_player.set_stream(music_list)
	current_music_player.set_autoplay(true)
	current_music_player.volume_db = music_volume

func setup_music_playlist() -> void:
	music_list = AudioStreamInteractive.new()
	music_list.set_clip_stream(0, music1)
	music_list.set_clip_stream(1, music2)
	music_list.set_initial_clip(0)

func rhythm_signal(every_beat: int) -> void:
	rhythm_notifier.beats(every_beat).connect(func(count):
		print("BEAT")
		beat.emit())
	#emit_signal(notify_signal)
	
	
