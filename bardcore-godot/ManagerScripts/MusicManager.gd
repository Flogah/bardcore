extends Node

@export var music_list = AudioStreamPlaylist
var current_music

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	music_list.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func change_music(index) -> void:
	current_music = music_list.instantiate()
	current_music.get_list_stream(index)
