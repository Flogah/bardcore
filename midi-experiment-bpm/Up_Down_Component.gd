@tool
extends Node

@export var max_move_up: int = 500
@export var max_move_down: int = 0
@export var move_speed: int = 20

@onready var platform: AnimatableBody2D = get_parent()
@onready var start_pos_y: int = int(platform.position.y)

func _ready() -> void:
	Schnittstelle.up.connect(move_up)
	Schnittstelle.down.connect(move_down)

func move_up():
	if platform.position.y > start_pos_y - max_move_up:
		platform.position.y -= move_speed

func move_down():
	if platform.position.y < start_pos_y + max_move_down:
		platform.position.y += move_speed
