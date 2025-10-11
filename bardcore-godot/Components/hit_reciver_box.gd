extends Area3D
class_name hit_reciver_box
##[/b] This component is the counterpart to [interaction_area], and is detected by it. [br][br]
## Other [interaction_area]s will call [method hit]. [br] 
## After a hit, the id of the [interaction_area] will be saved for the duration
## [member effect.incincability_time], to [u]prevent[/u] multiple hits from the same source in rapid succession. [br][br]
##[color='YELLOW']If this area wont be hit by an interaction area, make sure that [member owning_char.faction] is in [member interaction_area.targets].[/color][b]

@export var owning_char: CharacterBody2D
@export var health_comp: health_component

var e_type = effect.effect_type
var interacted_objects_id: Array[int]

func hit(id: int, type: effect.effect_type, amount: float, inv_time: float, statuses: Array[status]):
	if id not in interacted_objects_id: # invincability frame still active?:
		if health_comp: # do i have an health component?:
			health_comp.apply(type,amount)
		if inv_time > 0:
			add_id_with_timeout(id, inv_time)
	# TODO: apply_statuses(statuses)

func faction() -> int:
	return owning_char.char_faction

func add_id_with_timeout(id: int, timeout: float) -> void:
	var timer := Timer.new()
	interacted_objects_id.append(id)
	timer.wait_time = timeout
	timer.one_shot = true
	add_child(timer)
	timer.start()
	timer.timeout.connect(_on_timer_timeout.bind(id, timer))

func _on_timer_timeout(id: int, timer: Timer) -> void:
	interacted_objects_id.erase(id)
	timer.queue_free()
