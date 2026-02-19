extends Node
class_name Instrument

var player : Player
var player_num: int
var input

@export var weak_attack_cooldown:float = 3.0
@export var strong_attack_cooldown:float = 2.0

@export var attack_area: Area3D
@export var vfx_scene: PackedScene
@export var vfx_spawnpoint: Node3D
@export var combat_statemachine: StateMachine

func _ready() -> void:
	equip()

func equip():
	player = get_parent()
	player_num = player.player
	input = player.input
