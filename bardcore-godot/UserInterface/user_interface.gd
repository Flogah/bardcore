extends CanvasLayer

@export var time_left_label: Label
@export var time_progress_bar: ProgressBar
@export var fadeTimer: Timer

var shaking: bool = false
var current_intensity:float = -1.0
var max_fade:float = 0.0
var reset_pos:Vector2

#func _ready():
	#fadeTimer.timeout.connect(stop_shake)
	#reset_pos = time_left_label.position

#func _process(_delta):
	#if shaking:
		#apply_shake()
		#current_intensity *= fadeTimer.time_left / max_fade
	#else:
		#time_left_label.position = reset_pos

func update_time(time:float) -> void:
	update_label(time)
	update_progress_bar(time)

func update_label(time:float) -> void:
	time_left_label.text = str(snapped(time, 0.1))

func update_progress_bar(val:float) -> void:
	time_progress_bar.value = time_progress_bar.max_value - val

func update_progress_bar_max(val:float) -> void:
	time_progress_bar.max_value = val

func timer_shake(intensity:float, fade:float) -> void:
	max_fade = fade
	shaking = true
	fadeTimer.start(fade)
	current_intensity = intensity

func stop_shake():
	shaking = false
	current_intensity = -1.0

func apply_shake():
	time_left_label.position = randomOffset(.5)

func randomOffset(maxOffset) -> Vector2:
	var a = randf_range(-maxOffset, maxOffset)
	var b = randf_range(-maxOffset, maxOffset)
	return Vector2(a, b)
