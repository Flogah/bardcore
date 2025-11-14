extends Resource
class_name hit_effect
## This Resource holds the [member amount] and [member type] of an interaction.

enum effect_type {ATTACK,HEAL,STATUS}

@export var type: effect_type = effect_type.ATTACK
@export var amount: float = 10.0
@export var critical_multiplier: float = 2.0
@export var invincability_time: float = 0.2
@export var status_effects: Array[status] = []
