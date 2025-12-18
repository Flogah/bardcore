extends Node3D

@export var direction_arrow: bool = false
@export var color: Color

var mat: StandardMaterial3D

func _ready() -> void:
	$Arrow.visible = direction_arrow
	
	if !color:
		return
	
	mat = StandardMaterial3D.new()
	mat.albedo_color = color
	$Arrow.set_surface_override_material(0, mat)
	$Ring.set_surface_override_material(0, mat)

func set_color(new_color: Color) -> void:
	color = new_color
	mat = StandardMaterial3D.new()
	mat.albedo_color = new_color
	$Arrow.set_surface_override_material(0, mat)
	$Ring.set_surface_override_material(0, mat)
