@tool
extends Camera2D

@export var target:Node2D

@export var vertical_offset:int = -150

func _process(delta: float) -> void:
	if target:
		position = target.position + Vector2(0, vertical_offset)
