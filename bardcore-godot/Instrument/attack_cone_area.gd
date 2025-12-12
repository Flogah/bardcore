extends Node3D
var beatTimer: Timer
@export var attack_sound: AudioStreamPlayer3D
@onready var hit_emitter_box: hit_emitter_box = $hit_emitter_box


func _ready() -> void:
	#beatTimer = get_tree().get_first_node_in_group('BeatTimer')
	#unnecessary, it's already connected by hand (check your nodes)
	#attack_sound.finished.connect(clean_up)
	MusicManager.quarterBeat.connect(_on_triggered)
	print("beatTimer")

func _on_triggered() -> void:
	attack_sound.play()
	hit_emitter_box.hit_check()
	print("EXPLOSION!")
	MusicManager.quarterBeat.disconnect(_on_triggered)


func _on_audio_stream_player_3d_finished() -> void:
	print("clean up")
	queue_free()
