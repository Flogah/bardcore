extends Area3D
class_name hit_emitter_box
##This Component is used for any kind of interaction, that applys [effect]s. [br][br][/b]
##It can be used for projectiles to damage or heal overlapping [hit_reciever_box]es of factions in [member targets]. [b]

signal hit

@export var interaction_effect: effect 
@export var targets: Array[character.faction]

var critical: bool

func _physics_process(delta: float) -> void:
	var areas = self.get_overlapping_areas()
	for area in areas:
		if area is hit_reciver_box and area.faction() in targets: # Applys effect, if area is a hitbox and is one of defined target factions
			area.hit(
				get_instance_id(),
				interaction_effect.type,
				interaction_effect.amount * max(1, int(critical)*interaction_effect.critical_multiplier),
				interaction_effect.invincability_time,
				interaction_effect.status_effects
				)
			hit.emit()
