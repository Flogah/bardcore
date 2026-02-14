class_name Interactable
extends Area3D

var hint: InputHint
var closest_hands: Array[Area3D]

func _ready() -> void:
	# Only exist in interactable layer and no mask:
	monitoring = false
	monitorable = true
	set_collision_layer_value(1, false)
	set_collision_layer_value(4, true)
	set_collision_mask_value(1, false)

func interact() -> void:
	pass

func display_hint() -> void:
	pass

func remove_hint() -> void:
	pass

func append_player_hand_beeing_closest(hand: Area3D) -> void:
	closest_hands.append(hand)
	display_hint()

func remove_player_hand_beeing_closest(hand: Area3D) -> void:
	closest_hands.erase(hand)
	if closest_hands.size() < 1:
		remove_hint()
