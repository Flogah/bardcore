extends Control
class_name BardHUD

const LIEBHABER_PORTRAIT = preload("uid://bvpwo6w6kxci1")
const SAEUFER_PORTRAIT = preload("uid://b0ulghyxc1ddu")
const STAR_PORTRAIT = preload("uid://cono65sny6l7d")

var current_type: PlayerManager.bard_type
var player_num: int

@onready var health_bar: ProgressBar = $ProgressBar
@onready var portrait_links: TextureRect = $Control/TextureRect
@onready var portrait_rechts: TextureRect = $Control2/TextureRect2
@onready var progress_bar: ProgressBar = $ProgressBar

func setup_HUD(player: int):
	player_num = player
	set_type()
	if player == 0 or player == 2 :
		portrait_rechts.hide()
	else :
		portrait_links.hide()
	PlayerManager.player_data_updated.connect(set_type)
	var player_col = PlayerManager.get_player_color(player)
	var player_node = PlayerManager.player_nodes[player_num]
	var health_comp: health_component = player_node.health_comp
	health_comp.damaged.connect(update_health)
	health_comp.healed.connect(update_health)
	update_health(0, 0, health_comp.health)
	set_max_health(health_comp.max_health)
	progress_bar.get("theme_override_styles/background").bg_color = player_col

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

func update_health(_amount, _mod, new_h: float):
	health_bar.value = new_h

func set_max_health(new_value: float):
	health_bar.max_value = new_value
