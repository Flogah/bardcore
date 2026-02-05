extends Node3D
class_name CameraSystem

@onready var cam: Camera3D = $Camera3D

var shake_intensity: float = 0.0
var max_shake_time: float = 0.0

var shake_decay: float = 0.0

var shake_time: float = 0.0
var shake_time_speed: float = 20.0

var shaking: bool = false

func _physics_process(delta: float) -> void:
	if max_shake_time > 0:
		shake_time += delta * shake_time_speed
		max_shake_time -= delta
		
		cam.h_offset = randomize_offset(shake_intensity)
		cam.v_offset = randomize_offset(shake_intensity)
		
		shake_intensity = max(shake_intensity - shake_decay * delta, 0)
	
	else:
		cam.h_offset = lerp(cam.h_offset, 0.0, 10.5 * delta)
		cam.v_offset = lerp(cam.v_offset, 0.0, 10.5 * delta)

func begin_shake(intensity: float = .3, time: float = 3.0, decay: float= 0.2):
	shake_intensity = intensity
	max_shake_time = time
	shake_decay = decay
	shake_time = 0.0
	
	shaking = true

func stop_shaking():
	shaking = false

func randomize_offset(num:float) -> float:
	return randf_range(-num, num)
