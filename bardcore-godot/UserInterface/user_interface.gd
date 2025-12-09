extends CanvasLayer

@export var combat_ui: Control
@export var home_ui: Control

@export var time_left_label: Label
@export var time_progress_bar: ProgressBar
@export var build_time_label: Label
@export var fadeTimer: Timer

var max_fade:float = 0.0
var current_intensity : float = -1.0

func _ready():
	MusicManager.beat.connect(timer_beat)
	GameManager.game_state_changed.connect(change_ui_state)

func _process(_delta):
	shrink_timer()

func shrink_timer():
	if current_intensity > 1.0:
		time_left_label.scale = Vector2.ONE * current_intensity
		#build_time_label.scale = Vector2.ONE * current_intensity
		current_intensity *= fadeTimer.time_left / max_fade
	else:
		time_left_label.scale = Vector2.ONE
		#build_time_label.scale = Vector2.ONE

func update_time(time:float) -> void:
	update_time_label(time)
	update_progress_bar(time)

func update_time_label(time:float) -> void:
	time_left_label.text = str(snapped(time, 0.1))

func update_progress_bar(val:float) -> void:
	time_progress_bar.value = time_progress_bar.max_value - val

func update_build_label(val:int) -> void:
	build_time_label.text = str(val) + " Days until the dragon returns"

func update_progress_bar_max(val:float) -> void:
	time_progress_bar.max_value = val

func timer_beat(intensity:float = 1.2, fade:float = 100) -> void:
	max_fade = fade
	fadeTimer.start(fade)
	current_intensity = intensity

func change_ui_state(mode: GameManager.gameState):
	if mode == GameManager.gameState.home:
		combat_ui.hide()
		home_ui.show()
	elif mode == GameManager.gameState.combat:
		home_ui.hide()
		combat_ui.show()
	else:
		print("No specific UI available. Reverting to default.")
		home_ui.hide()
		combat_ui.show()
