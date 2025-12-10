extends Map

@onready var buildings_node: Node3D = $Buildings

@export var spawn_position:Node3D
@export var exit_portal:Portal

func _ready() -> void:
	load_buildings()
	exit_portal.on_enter_portal.connect(enter_run)
	GameManager.change_gamestate(mapGameState)
	spawn_players()
	UserInterface.update_build_label(GameManager.building_time)

func enter_run():
	save_buildings()
	MapManager.load_map()

func spawn_players():
	var players = PlayerManager.player_data
	for player in players:
		PlayerManager.spawn_player(player)

func save_buildings():
	var buildings = buildings_node.get_children()
	for building in buildings:
		GameManager.set_building(building)

func load_buildings():
	var buildings = buildings_node.get_children()
	for building in buildings:
		var b_name = building.building_name
		var new_state = GameManager.get_building_lvl(b_name)
		building.set_state(new_state)
