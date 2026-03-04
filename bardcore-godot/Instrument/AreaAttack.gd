extends Node3D

@export var trigger_on_beat: MusicManager.beatType
@export var place_sound: AudioStreamMP3
@export var attack_sound: AudioStreamMP3
@export var attack_sound_timing: float
@export var placement_damage: float

var beatTimer: Timer
var player_num: int

var angle_mod
var range_mod
var damage_mod

@onready var hit_emitter: hit_emitter_box = $hit_emitter_box
@onready var mesh_instance: MeshInstance3D = $MeshInstance3D
@onready var particles: GPUParticles3D = $GPUParticles3D
@onready var mat: ShaderMaterial = mesh_instance.get_surface_override_material(0)

func _ready() -> void:
	attack_sound.finished.connect(clean_up)
	mat.set_shader_parameter("AbilityProgress", 0.0)
	connect_to_beat()
	weak_hit()

func _process(_delta: float) -> void:
	if !beatTimer:
		return
	
	var progress = mat.get_shader_parameter("AbilityProgress")
	progress = beatTimer.time_left / beatTimer.wait_time
	mat.set_shader_parameter("AbilityProgress", progress)
	
	if beatTimer.time_left <= attack_sound_timing:
		attack_sound.play()

func set_sound_emitters():
	if place_sound:
		var place_sound_player = AudioStreamPlayer3D.new()
		place_sound_player.set_stream(place_sound)
		add_child(place_sound_player)
	if attack_sound:
		var attack_sound_player = AudioStreamPlayer3D.new()
		attack_sound_player.set_stream(attack_sound)
		add_child(attack_sound_player)

func set_bard_data(player: int):
	player_num = player
	var p_node: Player = PlayerManager.player_nodes[player_num]
	angle_mod = p_node.stat_comp.get_stat(stat_component.stat_id.ANGLE)
	range_mod = p_node.stat_comp.get_stat(stat_component.stat_id.RANGE)
	damage_mod = p_node.stat_comp.get_stat(stat_component.stat_id.OUT_DAMAGE)

func set_beat(type: MusicManager.beatType = MusicManager.beatType.beat):
	trigger_on_beat = type

func connect_to_beat():
	beatTimer = Timer.new()
	beatTimer.wait_time = MusicManager.get_time_to_next_beat(trigger_on_beat)
	beatTimer.autostart = true
	beatTimer.one_shot = true
	beatTimer.timeout.connect(strong_hit)
	add_child(beatTimer)

func weak_hit():
	hit_emitter.hit_effect.amount = placement_damage
	place_sound.play()
	particles.restart()
	hit_emitter.hit_check()

func strong_hit():
	hit_emitter.hit_effect.amount = damage_mod
	particles.restart()
	hit_emitter.hit_check()

func set_color():
	var player_col = PlayerManager.get_player_color(player_num)
	mat.set_shader_parameter("PlayerColor", player_col)

func clean_up():
	queue_free()
