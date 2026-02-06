extends Node
class_name Instrument

var player : Player
var player_num: int
var input

enum instrument_type {
	trumpet,
	fidel
}
@export var type: instrument_type
@export var weak_attack_cooldown:float = 3.0
@export var strong_attack_cooldown:float = 2.0
@export var damage_multiplier:float = 1.0

@export var attack_area: Area3D
@export var vfx_scene: PackedScene
@export var vfx_spawnpoint: Node3D
@export var combat_statemachine: StateMachine


var attack_cooldown_timer: Timer

func _ready() -> void:
	equip()
	setup_cd_timer()

func equip():
	player = get_parent()
	player_num = player.player
	input = player.input

func setup_cd_timer():
	print("No cooldown timer found. Creating new timer.")
	attack_cooldown_timer = Timer.new()
	add_child(attack_cooldown_timer)
	attack_cooldown_timer.one_shot = true
	attack_cooldown_timer.wait_time = 5.0
