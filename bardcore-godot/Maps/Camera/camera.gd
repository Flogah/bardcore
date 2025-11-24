extends Node3D

@onready var camera_3d: Camera3D = $Camera3D

var shaking: bool = false
var current_intensity:float = -1.0
var max_fade:float = 0.0
#
#func _ready():
	#fadeTimer.timeout.connect(stop_screen_shake)
#
#func _process(delta):
	#if shaking:
		#apply_shake()
		#current_intensity *= fadeTimer.time_left / max_fade
	#else:
		#camera_3d.position = Vector3(0, 0, camera_3d.position.z)
#
#func screen_shake(intensity, fade):
	#max_fade = fade
	#shaking = true
	#fadeTimer.start(fade)
	#current_intensity = intensity
#
#func stop_screen_shake():
	#shaking = false
	#current_intensity = -1.0
#
#func apply_shake():
	#var shakevec = Vector3(randomOffset(current_intensity).x, randomOffset(current_intensity).y, camera_3d.position.z)
	#camera_3d.position = shakevec
#
#func randomOffset(maxOffset) -> Vector2:
	#var a = randf_range(-maxOffset, maxOffset)
	#var b = randf_range(-maxOffset, maxOffset)
	#return Vector2(a, b)
