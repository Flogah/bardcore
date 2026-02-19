extends Node

@export var current_music: AudioStreamPlayer
var music_player_1: AudioStreamPlayer
var music_player_2: AudioStreamPlayer
var beatTimer: Timer
var music_volume = -20

enum music_tracks {
	VILLAGE,
	COMBAT,
}

var background_music: Dictionary = {
	music_tracks.VILLAGE: preload("uid://bwm12bt8i2t00"),
	music_tracks.COMBAT: preload("uid://cgp353opwrx4t")
}

var stats_music: Dictionary = {
	null: music_tracks.VILLAGE,
	GameManager.gameState.home: music_tracks.VILLAGE,
	GameManager.gameState.combat: music_tracks.COMBAT,
	GameManager.gameState.post_combat: music_tracks.VILLAGE,
	GameManager.gameState.shop: music_tracks.VILLAGE,
}

@export var rhythm_notifier: RhythmNotifier
signal beat
signal halfBeat
signal thirdBeat
signal quarterBeat
signal eighthBeat

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.game_state_changed.connect(change_music_to_new_state)
	setup_music_player()
	setup_music()
	setup_rhythm()
	setup_timer()
	beats()
	half_beat()
	third_beat()
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
	music_player_1.set_stream(background_music[music_tracks.VILLAGE])
	music_player_2.set_stream(background_music[music_tracks.COMBAT])


func beats() -> void:
	rhythm_notifier.beats(1).connect(func(count):
		#print("BEAT")
		beat.emit())
		
func half_beat() -> void:
	rhythm_notifier.beats(2).connect(func(count):
		#print("BEAT")
		halfBeat.emit())
		
func third_beat() -> void:
	rhythm_notifier.beats(3).connect(func(count):
		#print("BEAT")
		thirdBeat.emit())
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

func change_music_to_new_state(gameState: GameManager.gameState):
	var new_music_stream = background_music[stats_music[gameState]]
	if current_music.stream != new_music_stream:
		if current_music != music_player_1:
			music_player_1.set_stream(background_music[stats_music[gameState]])
			change_music(music_player_2, music_player_1)
		else:
			music_player_2.set_stream(background_music[stats_music[gameState]])
			change_music(music_player_1, music_player_2)
	
