extends Area3D
class_name hit_emitter_box
##This Component is used for any kind of interaction, that applys [effect]s. [br][br][/b]
##It can be used for projectiles to damage or heal overlapping [hit_reciever_box]es of factions in [member targets]. [b]

signal hit

enum faction {
	Player,
	Enemy,
	Environment,
}

@export var interaction_effect: effect 
@export var targets: Array[faction]

var critical: bool

func _physics_process(_delta: float) -> void:
	var areas = self.get_overlapping_areas()
	for area in areas:
		if area is hit_reciver_box:
			var acceptable_targets = faction.keys()
			for group in area.owner.get_groups():
				if group in acceptable_targets:
					deal_hit(area)
					return

func deal_hit(area:hit_reciver_box):
	area.hit(
		get_instance_id(),
		interaction_effect.type,
		interaction_effect.amount * max(1, int(critical)*interaction_effect.critical_multiplier),
		interaction_effect.invincability_time,
		interaction_effect.status_effects
		)
	hit.emit()
