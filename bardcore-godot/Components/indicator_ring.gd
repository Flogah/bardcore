extends Node3D

@export var direction_arrow: bool = false
@export var color: Color

func _ready() -> void:
	$Arrow.visible = direction_arrow
	$Arrow.mesh.material.albedo_color = color
	$Ring.mesh.material.albedo_color = color

func set_color(new_color: Color) -> void:
	color = new_color
	$Arrow.mesh.material.albedo_color = color
	$Ring.mesh.material.albedo_color = color
