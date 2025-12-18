extends Interactable
class_name droppable_item

enum item_type {
	RING,
	HELMET,
	TORSO,
	BOOTS,
	INSTRUMENT,
}

const PLACEHOLDER_MESHES := {
	item_type.RING: "res://BlenderScenes/PlaceHolder_Ringwear.blend",
	item_type.HELMET: "res://BlenderScenes/PlaceHolder_Headwear.blend",
	item_type.TORSO: "res://BlenderScenes/PlaceHolder_Torsowear.blend",
	item_type.BOOTS: "res://BlenderScenes/PlaceHolder_Footwear.blend",
	item_type.INSTRUMENT: "res://BlenderScenes/PlaceHolder_Ringwear.blend",
}

@export var item_resource_: item_resource = load("res://Resources/Items/default_item.tres")

@export var pickup_area: Area3D
@export var item_label: Label3D

var item_label_text: String

var item_mesh: Node3D

func _ready() -> void:
	if item_resource_.mesh:
		item_mesh = item_resource_.mesh.instantiate()
	else:
		var scene_path = PLACEHOLDER_MESHES[item_resource_.type]
		var scene = load(scene_path)
		if scene and scene is PackedScene:
			item_mesh = scene.instantiate()
		else:
			push_error("Fehler: Platzhalter konnte nicht geladen werden: %s" % scene_path)
			return
	add_child(item_mesh)
	update_item_label()

func _process(delta: float) -> void:
	if !item_mesh:return
	item_mesh.rotate(Vector3.UP, delta * deg_to_rad(25))
	item_mesh.position.y = lerp(item_mesh.position.y + 1, sin(Time.get_ticks_msec()/300.0)*0.5 + 1, 0.5)

#func check_if_item_info_should_be_displayed(_entered_or_exited_body: Node3D) -> void:
	#print("checking")
	#for body in pickup_area.get_overlapping_bodies():
		#if body is Player:
			#print("contains player")
			#item_label.text = item_label_text
			#return
	#item_label.text = ""

func update_item_label() -> void:
	var label_text: String = item_resource_.name
	for _upgrade in item_resource_.upgrades:
		label_text += "\n" + _upgrade.explanation
	item_label_text = label_text


func _on_area_3d_area_entered(_area: Area3D) -> void:
	if hint: return
	hint = UserInterface.create_hint(global_position, item_label_text, true)

func _on_area_3d_area_exited(_area: Area3D) -> void:
	hint.queue_free()
