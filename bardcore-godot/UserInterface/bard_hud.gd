extends Control
class_name BardHUD

const LIEBHABER_PORTRAIT = preload("uid://bvpwo6w6kxci1")
const SAEUFER_PORTRAIT = preload("uid://b0ulghyxc1ddu")
const STAR_PORTRAIT = preload("uid://cono65sny6l7d")

var current_type: PlayerManager.bard_type
var player_num: int
var health_comp

@onready var health_bar: ProgressBar = $ProgressBar
@onready var portrait_links: TextureRect = $Control/TextureRect
@onready var portrait_rechts: TextureRect = $Control2/TextureRect2
@onready var progress_bar: ProgressBar = $ProgressBar
@onready var hp_label: Label = $ProgressBar/Control/HPLabel

func setup_HUD(player: int):
	player_num = player
	health_comp = PlayerManager.player_nodes[player_num].health_comp
	set_type()
	if player == 0 or player == 2 :
		portrait_rechts.hide()
	else :
		portrait_links.hide()
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
		portrait_links.texture = LIEBHABER_PORTRAIT
		portrait_rechts.texture = LIEBHABER_PORTRAIT
	elif current_type == PlayerManager.bard_type.relic:
		portrait_links.texture = SAEUFER_PORTRAIT
		portrait_rechts.texture = SAEUFER_PORTRAIT
	else:
		portrait_links.texture = STAR_PORTRAIT
		portrait_rechts.texture = STAR_PORTRAIT

func update_health(_n = 0, _m = 1, health: float = 2):
	var new_health = health_comp.health
	var new_max_health = health_comp.max_health
	health_bar.max_value = new_max_health
	health_bar.value = min(new_health, new_max_health)
	hp_label.text = str(max(snapped(health_bar.value, 1), 0))
