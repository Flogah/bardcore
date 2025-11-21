extends Node

var music_list: Array
@export var current_music: AudioStream
var music_player_1: AudioStreamPlayer
var music_player_2: AudioStreamPlayer
var beatTimer: Timer
var music_volume = -20
var music1 = preload("uid://cgp353opwrx4t")
var music2 = preload("uid://dc23co36v6bdl")
@export var rhythm_notifier: RhythmNotifier
signal beat

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	setup_music_playlist()
	
	setup_music_player(music_list[0])
	setup_music_player(music_list[1])
	setup_music()
	setup_rhythm()
	setup_timer()
	rhythm_signal(2)
	play_music(music_player_1)

func setup_music() -> void:
	pass

func change_music(index: int) -> void:
	pass

func play_music(audiostreamplayer: AudioStreamPlayer) -> void:
	audiostreamplayer.play()

func setup_rhythm() -> void:
	rhythm_notifier = RhythmNotifier.new()
	add_child(rhythm_notifier)
	rhythm_notifier.bpm = 120
	rhythm_notifier.audio_stream_player = music_player_1

func setup_timer() -> void:
	beatTimer = Timer.new()
	add_child(beatTimer)
	beatTimer.start(3.0)

func setup_music_player(asp: AudioStreamPlayer) -> void:
	asp = AudioStreamPlayer.new()
	add_child(asp)
	asp.set_autoplay(true)
	asp.volume_db = music_volume
	music_player_1.set_stream(music1)
	music_player_2.set_stream(music2)

func setup_music_playlist() -> void:
	music_list.resize(2)
	music_list.insert(0, music_player_1)
	music_list.insert(1, music_player_2)

func rhythm_signal(every_beat: int) -> void:
	rhythm_notifier.beats(every_beat).connect(func(count):
		print("BEAT")
		beat.emit())
	#emit_signal(notify_signal)
	
	
