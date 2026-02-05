extends Node3D
@onready var torus := $Node/Torus
var material : ShaderMaterial
var health_comp: health_component

func _ready():
	await get_tree().create_timer(.5).timeout
	var original = torus.get_active_material(0)
	
	material = original.duplicate(true) as ShaderMaterial
	torus.set_surface_override_material(0,material)

	health_comp = get_parent().get_node("HealthComponent")

	health_comp.damaged.connect(_on_health_changed)
	health_comp.healed.connect(_on_health_changed)

	_update_ring(health_comp.health)

func _on_health_changed(amount, modified_amount, health):
	_update_ring(health)

func _update_ring(health: float):
	var ratio: float = clamp(health_comp.health / health_comp.max_health, 0.0, 1.0)
	material.set_shader_parameter("health_ratio", ratio)
