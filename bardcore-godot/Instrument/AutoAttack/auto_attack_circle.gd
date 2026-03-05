extends Node3D
class_name AutoAttackCircle

@onready var hit_emitter: hit_emitter_box = $hit_emitter_box
@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var mat: ShaderMaterial = mesh.get_surface_override_material(0)
@onready var particles: GPUParticles3D = $GPUParticles3D
@onready var audio: AudioStreamPlayer3D = $AudioStreamPlayer3D

var beat_mode: MusicManager.beatType = MusicManager.beatType.beat

func _ready() -> void:
	MusicManager.beat.connect(trigger_attack)
	#global_position = PlayerManager.player_nodes[owner.player_num].global_position
	position = Vector3.ZERO
	global_position.y = .01

func _process(delta: float) -> void:
	update_visual()

func update_visual():
	var player_col = PlayerManager.get_player_color(owner.player_num)
	mat.set_shader_parameter("PlayerColor", player_col)
	
	var progress = mat.get_shader_parameter("AbilityProgress")
	progress = MusicManager.get_time_to_next_beat(MusicManager.beatType.beat) * 2/ MusicManager.beatType.beat
	mat.set_shader_parameter("AbilityProgress", progress)

func trigger_attack():
	#audio.play()
	particles.restart()
	hit_emitter.hit_check()
