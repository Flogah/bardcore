extends Node3D
class_name inventory_component

#@export var tele_comp: telegraphing_component
@export var stat_comp: stat_component

var pickupable_items: Array[droppable_item]
var pickup_item: droppable_item

var slots: Dictionary[int, Array] = {
	droppable_item.item_type.RING: [],
	droppable_item.item_type.HELMET: [],
	droppable_item.item_type.TORSO: [],
	droppable_item.item_type.BOOTS: [],
	droppable_item.item_type.INSTRUMENT: [],
}

const SLOT_TYPE_SIZE := {
	droppable_item.item_type.HELMET: stat_component.stat_id.HELMET_SLOTS,
	droppable_item.item_type.TORSO: stat_component.stat_id.TORSO_SLOTS,
	droppable_item.item_type.BOOTS: stat_component.stat_id.BOOTS_SLOTS,
	droppable_item.item_type.RING: stat_component.stat_id.RING_SLOTS,
}

func _ready() -> void:
	await get_tree().create_timer(0.1).timeout
	for type in SLOT_TYPE_SIZE.keys():
		stat_comp.stats[type].changed.connect(drop_overflowing_itmes)

func pickup(item: droppable_item) -> void: #call this if a item should be forced into a slot
	slots[item.item_resource_.type].append(item)
	stat_comp.add_upgrades(item.get_instance_id(),item.item_resource_.upgrades)
	item.get_parent().remove_child(item)
	drop_overflowing_itmes(item.item_resource_.type)
	

func drop(item_type: droppable_item.item_type) -> void:
	var slot = slots[item_type]
	if slot[0] is droppable_item:
		MapManager.get_current_map().add_child(slot[0])
		slot[0].global_position = global_position + global_basis.z * -5
		stat_comp.remove_upgrades(slot[0].get_instance_id())
		slot.remove_at(0)

func drop_all():
	for type in droppable_item.item_type:
		drop(type)

func drop_overflowing_itmes(item_type: droppable_item.item_type) -> void:
	var slot = slots[item_type]
	if item_type == droppable_item.item_type.INSTRUMENT:
		if slot.size() > 1:
			drop(item_type)
			return
	while slot.size() > int(stat_comp.get_stat(SLOT_TYPE_SIZE[item_type])):
		drop(item_type)
	return
