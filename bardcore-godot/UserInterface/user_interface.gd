extends CanvasLayer

@onready var time_left_label: Label = $Control/TimeContainer/VBoxContainer/TimeLeft
@onready var time_progress_bar: ProgressBar = $Control/TimeContainer/VBoxContainer/TimeProgressBar
@onready var fadeTimer: Timer = $Control/TimeContainer/VBoxContainer/FadeTimer

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

func update_label(time:float) -> void:
	time_left_label.text = str(time)

func update_prograss_bar(now_val:float, max_val:float) -> void:
	time_progress_bar.max_value = max_val
	time_progress_bar.value = now_val

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
