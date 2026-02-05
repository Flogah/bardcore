extends Map
class_name combat_map

signal all_enemies_dead


@export var right_portal:Portal
@export var left_portal:Portal

var enemies = []
var portals = []


@onready var enemy_nodes: Node3D = $Enemies
@onready var exit_nodes: Node3D = $Exits

func _ready() -> void:
	find_enemies()
	find_portals()
	connect_portals()
	#get_tree().create_timer(1.0).timeout.connect(check_for_surviving_enemies)

func find_enemies():
	for enemy in enemy_nodes.get_children():
		if !enemy.dead:
			enemies.append(enemy)
			enemy.died.connect(check_for_surviving_enemies)

func find_portals():
	for portal in exit_nodes.get_children():
		portals.append(portal)

func connect_portals():
	if right_portal:
		right_portal.on_enter_portal.connect(exit_right)
	if left_portal:
		left_portal.on_enter_portal.connect(exit_left)
	all_enemies_dead.connect(unlock_all_portals)

func unlock_all_portals():
	mapGameState = GameManager.gameState.post_combat
	GameManager.change_gamestate(GameManager.gameState.post_combat)
	for bard in bards:
		bard.full_restore()
	for portal in portals:
		portal.unlock()
	
func lock_all_portals():
	for portal in portals:
		portal.lock()

func lock_unlock_all_portals():
	lock_all_portals()
	var unlock_timer = Timer.new()
	unlock_timer.one_shot = true
	unlock_timer.autostart = true
	unlock_timer.timeout.connect(unlock_all_portals)
	add_child(unlock_timer)

func exit_left():
	MapManager.go_left()

func exit_right():
	MapManager.go_right()

func spawn_players():
	if PlayerManager.player_nodes.is_empty():
		return
	
	var entrance
	if MapManager.coming_from_left:
		entrance = left_portal.spawn_center.global_position
	else:
		entrance = right_portal.spawn_center.global_position
	
	var player_nodes = PlayerManager.player_nodes
	for player_node in player_nodes:
		var player = player_nodes[player_node]
		#var cur_scene = get_tree().get_current_scene()
		var cur_scene = MapManager.get_current_map()
		if cur_scene:
			cur_scene.add_child(player)
			bards.append(player)
			player.knocked_out.connect(check_for_game_over)
			player.position = entrance
			entrance.z += 2.0
	
	bards_spawned.emit()
	if mapGameState == GameManager.gameState.combat:
		lock_all_portals()

func check_for_surviving_enemies():
	if game_over:
		return
	
	await get_tree().create_timer(0.1).timeout
	var bodies = enemy_nodes.get_children()
	for body in enemies:
		if !body.dead:
			return
	all_enemies_dead.emit()
	print("all dead")

func check_for_game_over():
	for bard in bards:
		if bard.can_attack:
			return
	
	game_over = true
	GameManager.speed_up_dragon_timer()

func game_over_cinema():
	game_over = true
	lock_all_portals()
	arrive_dragon()
