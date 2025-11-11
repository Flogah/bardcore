extends Node

var music_list = []
var current_music: AudioStreamPlayer
@export var clips: Node
var beatTimer: Timer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	beatTimer = Timer.new()
	add_child(beatTimer)
	beatTimer.start(3.0)
	play_music("Music")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func change_music(index) -> void:
	current_music = index
	#play_music("Music")

func play_music(audio_name: String, from_position: float = 0.0) -> void:
	current_music = clips.get_node(audio_name)
	current_music.play(from_position)
