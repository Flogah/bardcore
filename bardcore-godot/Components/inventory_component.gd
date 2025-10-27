extends Node
class_name inventory_component

var slots = {
	droppable_item.item_type.RING: [],
	droppable_item.item_type.HELMET: null,
	droppable_item.item_type.TORSO: null,
	droppable_item.item_type.BOOTS: null,
	droppable_item.item_type.INSTRUMENT: null,
}

func pickup(item: droppable_item) -> void:
	var slot = slots[item.type]
	drop(item.type)
	if slot is Array:
		slot.append(item)
	elif slot is droppable_item:
		slot = item

func drop(item_type: droppable_item.item_type) -> void:
	var slot = slots[item_type]
	if slot is Array:
		if slot.size() >= 2:
			if slot[0] is droppable_item:
				get_tree().add_child(slot.pop_at(0))
	elif slot is droppable_item:
		get_tree().add_child(slot)
		slots[item_type] = null
