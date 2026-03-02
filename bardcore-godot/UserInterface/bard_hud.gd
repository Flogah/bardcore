extends Control
class_name BardHUD

const LIEBHABER_PORTRAIT_HOLZSCHNITT_2 = preload("uid://ds4ktephg6tuq")
const SAEUFER_PORTRAIT_HOLZSCHNITT_2 = preload("uid://vulycxh5qme7")
const GODOT_ICON = preload("uid://cbrmi5k31lw24")

var current_type: PlayerManager.bard_type
var player_num: int

@onready var health_comp: health_component = PlayerManager.player_nodes[player_num].health_comp
@onready var health_bar: ProgressBar = $ProgressBar
@onready var portrait: TextureRect = $Control/TextureRect
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var hp_label: Label = $ProgressBar/Control/HPLabel

func setup_HUD(player: int):
	player_num = player
	PlayerManager.player_data_updated.connect(set_type)
	set_type()
	health_comp.damaged.connect(update_health)
	health_comp.healed.connect(update_health)
	get_tree().create_timer(.1).timeout.connect(set_HUD_numbers)

func set_HUD_numbers():
	var player_col = PlayerManager.get_player_color(player_num)
	progress_bar.get("theme_override_styles/background").bg_color = player_col
	update_health()

func set_type():
	current_type = PlayerManager.player_data[player_num]["bard"]
	if current_type == PlayerManager.bard_type.lover:
		portrait.texture = LIEBHABER_PORTRAIT_HOLZSCHNITT_2
	elif current_type == PlayerManager.bard_type.relic:
		portrait.texture = SAEUFER_PORTRAIT_HOLZSCHNITT_2
	else:
		portrait.texture = GODOT_ICON

func update_health(_n = 0, _m = 1, health: float = 2):
	var new_health = health_comp.health
	var new_max_health = health_comp.max_health
	health_bar.max_value = new_max_health
	health_bar.value = new_health
	hp_label.text = str(max(snapped(health_comp.health, 1), 0))
