extends CanvasLayer

@export var time_left_label: Label
@export var time_progress_bar: ProgressBar
@export var fadeTimer: Timer

var max_fade:float = 0.0
var current_intensity : float = -1.0

func _ready():
	MusicManager.beat.connect(timer_beat)

func _process(_delta):
	if current_intensity > 1.0:
		time_left_label.scale = Vector2.ONE * current_intensity
		current_intensity *= fadeTimer.time_left / max_fade
	else:
		time_left_label.scale = Vector2.ONE

func update_time(time:float) -> void:
	update_label(time)
	update_progress_bar(time)

func update_label(time:float) -> void:
	time_left_label.text = str(snapped(time, 0.1))

func update_progress_bar(val:float) -> void:
	time_progress_bar.value = time_progress_bar.max_value - val

func update_progress_bar_max(val:float) -> void:
	time_progress_bar.max_value = val

func timer_beat(intensity:float = 1.4, fade:float = 0.6) -> void:
	max_fade = fade
	fadeTimer.start(fade)
	current_intensity = intensity
