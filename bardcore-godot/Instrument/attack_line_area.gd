extends Node3D

var beatTimer: Timer

@export var attack_sound: AudioStreamPlayer3D
@export var place_sound: AudioStreamPlayer3D

@onready var hit_emitter_box: hit_emitter_box = $hit_emitter_box
@onready var mesh_instance: MeshInstance3D = $MeshInstance3D
@onready var hit_emitter_box_2: hit_emitter_box = $hit_emitter_box2
@onready var particles: GPUParticles3D = $GPUParticles3D

func _ready() -> void:
	#beatTimer = get_tree().get_first_node_in_group('BeatTimer')
	#unnecessary, it's already connected by hand (check your nodes)
	#attack_sound.finished.connect(clean_up)
	place_sound.play()
	hit_emitter_box_2.hit_check()
	MusicManager.halfBeat.connect(_on_triggered)
	print("beatTimer")

func _on_triggered() -> void:
	particles.restart()
	attack_sound.play()
	hit_emitter_box.hit_check()
	print("EXPLOSION!")
	MusicManager.halfBeat.disconnect(_on_triggered)

func clean_up() -> void:
	print("clean up")
	queue_free()

func set_color(player_num: int):
	print(player_num)
	var new_mat = StandardMaterial3D.new()
	var player_col = PlayerManager.get_player_color(player_num)
	new_mat.albedo_color = player_col
	print(player_col)
	mesh_instance.set_surface_override_material(0, new_mat)
