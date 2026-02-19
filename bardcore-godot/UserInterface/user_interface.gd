extends CanvasLayer

const INPUT_HINT = preload("uid://bfs4dssi0ep7u")

@export var combat_ui: Control
@export var home_ui: Control
@export var gen_ui: Control
@export var upgrade_hint_label: Label

@export var time_left_label: Label
@export var time_progress_bar: ProgressBar
@export var build_time_label: Label
@export var fadeTimer: Timer

var max_fade:float = 0.0
var current_intensity : float = -1.0

func _ready():
	MusicManager.beat.connect(timer_beat)
	GameManager.game_state_changed.connect(change_ui_state)
	GameManager.building_time_changed.connect(update_build_label)

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
	if val == 0:
		build_time_label.text = "Der Drache kommt!"
		add_dragon_pointer()
	elif val == 1:
		build_time_label.text = str(val) + " Tag bis der Drache wiederkehrt"
	else:
		build_time_label.text = str(val) + " Tage bis der Drache wiederkehrt"

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

func add_dragon_pointer():
	var dragon_warning = preload("res://UserInterface/dragon_warning.tscn").instantiate()
	add_child(dragon_warning)

func show_upgrade_hint(building: Building):
	update_upgrade_hint(building)
	upgrade_hint_label.show()

func update_upgrade_hint(building: Building):
	var upgrade_txt = "Name: {0} lv.{1} \n Kosten: {2} Days \n F to Upgrade"
	var b_name: String = building.building_name
	var state: String = str(building.state)
	var cost: String = str(building.get_current_upgrade_cost())
	
	upgrade_hint_label.text = upgrade_txt.format([b_name, state, cost])

func hide_upgrade_hint():
	upgrade_hint_label.hide()

func create_hint(pos:Vector3, text:String, interaction_required:bool) -> InputHint:
	var hint = INPUT_HINT.instantiate()
	gen_ui.add_child(hint)
	hint.set_hint(project(pos), text, interaction_required)
	return hint

func project(pos: Vector3) -> Vector2:
	var camera : Camera3D = get_tree().get_first_node_in_group("Camera")
	return camera.unproject_position(pos)
