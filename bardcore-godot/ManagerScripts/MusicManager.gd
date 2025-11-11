extends Node

var music_list = []
@export var current_music: AudioStreamPlayer
var beatTimer: Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	beatTimer = Timer.new()
	add_child(beatTimer)
	beatTimer.start(3.0)
	current_music = AudioStreamPlayer.new()
	add_child(current_music)
	current_music.play()

func change_music(index) -> void:
	current_music = index
	#play_music("Music")

func play_music(from_position: float = 0.0) -> void:
	current_music.play(from_position)
