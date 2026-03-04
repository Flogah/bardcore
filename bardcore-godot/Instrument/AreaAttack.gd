extends Node3D
class_name AttackArea

signal attack_sound_finished

@export var trigger_on_beat: MusicManager.beatType = MusicManager.beatType.beat
@export var place_sound: AudioStream
@export var attack_sound: AudioStream
@export var attack_sound_timing: float = 0.0
@export var placement_damage: float = 5.0

var beatTimer: Timer
var sfx_timer: Timer
var player_num: int

var angle_mod
var range_mod
var damage_mod

var place_sound_player
var attack_sound_player

var attack_sound_playing: bool = false

@onready var hit_emitter: hit_emitter_box = $hit_emitter_box
@onready var mesh_instance: MeshInstance3D = $MeshInstance3D
@onready var particles: GPUParticles3D = $GPUParticles3D
@onready var mat: ShaderMaterial = mesh_instance.get_surface_override_material(0)

func _ready() -> void:
	mat.set_shader_parameter("AbilityProgress", 0.0)
	set_color()
	set_sound_emitters()
	connect_to_beat()
	
	weak_hit()

func _process(_delta: float) -> void:
	if !beatTimer:
		return
	
	var progress = mat.get_shader_parameter("AbilityProgress")
	progress = (beatTimer.wait_time - beatTimer.time_left) / beatTimer.wait_time
	mat.set_shader_parameter("AbilityProgress", progress)

func set_sound_emitters():
	if place_sound:
		place_sound_player = AudioStreamPlayer3D.new()
		place_sound_player.set_stream(place_sound)
		add_child(place_sound_player)
	if attack_sound:
		attack_sound_player = AudioStreamPlayer3D.new()
		attack_sound_player.set_stream(attack_sound)
		add_child(attack_sound_player)
		
		attack_sound_player.finished.connect(clean_up)

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
	
	
	sfx_timer = Timer.new()
	sfx_timer.wait_time = MusicManager.get_time_to_next_beat(trigger_on_beat) + attack_sound_timing
	sfx_timer.autostart = true
	sfx_timer.one_shot = true
	sfx_timer.timeout.connect(play_attack)
	
	add_child(beatTimer)
	add_child(sfx_timer)

func weak_hit():
	#hit_emitter.hit_effect.amount = placement_damage
	place_sound_player.play()
	particles.restart()
	hit_emitter.hit_check()

func strong_hit():
	#hit_emitter.hit_effect.amount = damage_mod
	particles.restart()
	hit_emitter.hit_check()
	mesh_instance.hide()

func play_attack():
	attack_sound_player.play()

func set_color():
	var player_col = PlayerManager.get_player_color(player_num)
	mat.set_shader_parameter("PlayerColor", player_col)

func clean_up():
	attack_sound_finished.emit()
