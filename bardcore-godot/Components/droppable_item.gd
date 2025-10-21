extends Node
class_name droppable_item

enum item_type {
	RING,
	HELMET,
	TORSO,
	BOOTS,
	INSTRUMENT,
}

@export var type: item_type = item_type.RING
