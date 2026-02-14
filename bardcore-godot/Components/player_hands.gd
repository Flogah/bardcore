extends Area3D
class_name PlayerHands

var closest_interactable: Interactable = null
@onready var check_timer: Timer = $"Check Timer"

func _on_area_entered(area: Area3D) -> void:
	if get_overlapping_areas().size() == 1:
		closest_interactable = area
		closest_interactable.append_player_hand_beeing_closest(self)
	else:
		check_closest()
		check_timer.start()

func _on_area_exited(area: Area3D) -> void:
	var overlapping_areas_size: int = get_overlapping_areas().size()
	area.remove_player_hand_beeing_closest(self)
	if overlapping_areas_size < 1:
		check_timer.stop()
		closest_interactable.remove_player_hand_beeing_closest(self)
	elif overlapping_areas_size == 1:
		check_timer.stop()
		closest_interactable = get_overlapping_areas()[0]

func check_closest() -> void:
	var closest: Interactable = get_overlapping_areas()[0]
	var closest_distance: float = closest.global_position.distance_to(self.global_position)
	for area in get_overlapping_areas():
		var distance_to_area: float = area.global_position.distance_to(self.global_position)
		if distance_to_area < closest_distance:
			closest = area as Interactable
			closest_distance = distance_to_area
	if closest != closest_interactable:
		closest_interactable.remove_player_hand_beeing_closest(self)
		closest_interactable = closest
		closest_interactable.append_player_hand_beeing_closest(self)
