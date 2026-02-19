extends Interactable
class_name loot_chest

@export_range(1,5,1.0) var drops: int = 3

var drop_item: PackedScene = load("res://Objects/droppable_item.tscn")

var item_resources: Array[item_resource] = []

var locked: bool = true
var opened: bool = false

func interact():
	if !locked:
		open()

func _ready() -> void:
	MapManager.current_map.bards_spawned.connect(get_ready)

func get_ready():
	read_all_loot()
	if GameManager.currentGameState == GameManager.gameState.post_combat:
		unlock()
	else:
		GameManager.game_state_changed.connect(check_for_safety)

func read_all_loot():
	for path in ResourceLoader.list_directory("res://Resources/Items"):
		item_resources.append(load("res://Resources/Items/" + path))

func check_for_safety(gameState: GameManager.gameState):
	if gameState != GameManager.gameState.combat:
		unlock()

func unlock() -> void:
	locked = false

func lock() -> void:
	locked = true

func open() -> void:
	if !opened:
		opened = true
		var lid := $PlaceHolder_Chest/Box/Lid
		var lid_tween: Tween = lid.create_tween()
		lid_tween.set_trans(Tween.TRANS_BOUNCE)
		lid_tween.set_ease(Tween.EASE_OUT)
		lid_tween.tween_property(
			lid,
			"rotation_degrees:z",
			100.0,
			1.0
		)
		for item in generate_loot():
			MapManager.get_current_map().add_child(item)
			item.global_position = position
			_throw_item(item)


func generate_loot() -> Array[droppable_item]:
	var items: Array[droppable_item]
	for i in range(drops):
		var new_item: droppable_item = drop_item.instantiate()
		new_item.item_resource_ = item_resources[randi_range(0, item_resources.size()-1)]
		items.append(new_item)
	return items

func _throw_item(item: Node3D) -> void:
	var tween := item.create_tween()
	tween.set_trans(Tween.TRANS_QUART)
	tween.set_ease(Tween.EASE_OUT)

	# Vorwärtsrichtung der Kiste
	var forward: Vector3 = global_transform.basis.x.normalized()

	# Zufälliger Winkel ±90°
	var angle := deg_to_rad(randf_range(-45.0, 45.0))
	var direction := forward.rotated(Vector3.UP, angle)

	# Parameter
	var distance := randf_range(4.0, 7.0)
	var height := randf_range(0.8, 1.4)
	var duration := randf_range(0.6, 0.9)

	var start_pos := item.global_position
	var peak_pos := start_pos + direction * (distance * 0.5) + Vector3.UP * height
	var end_pos := start_pos + direction * distance

	# Zweistufiger Tween = Bogen
	tween.tween_property(item, "global_position", peak_pos, duration * 0.5)
	tween.tween_property(item, "global_position", end_pos, duration * 0.5)


func display_hint() -> void:
	if hint: return
	if locked: return
	hint = UserInterface.create_hint(global_position, "Kiste", true)


func remove_hint() -> void:
	if hint: hint.queue_free()
