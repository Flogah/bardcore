extends Node
class_name Instrument

@export var weak_attack_cooldown:float = .6
@export var strong_attack_cooldown:float = 2.0

@export var attack_area: Area3D
@export var vfx_scene: PackedScene
@export var vfx_spawnpoint: Node3D
@export var combat_statemachine: StateMachine
