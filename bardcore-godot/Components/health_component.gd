extends Node
class_name health_component


##[/b]This component adds health to its parent. [br][br]
##If you assign this in the [hitbox_component] for it be able to work.[br]
##If you want to telegraph changes, add a [telegraph_component] and assign it here to [member telegraph_comp].[b]

signal died
signal damaged

#@export var telegraph_comp: telegraphing_component
@export var stat_comp: stat_component
@export var health_bar: Label
@export_range(10,1000,10) var max_health: float = 100

var health: float

func _ready() -> void:
	health = max_health

func _process(_delta: float) -> void:
	if health_bar: health_bar.text = str(health)
	if health <= 0:
		died.emit()

func apply(type: hit_effect.effect_type, amount: float):
	#if telegraph_comp: telegraph_comp.display_number(amount, type)
	if type == hit_effect.effect_type.ATTACK:
		damage( amount * stat_comp.get_stat(stat_comp.stat_id.IN_DAMAGE) )
		damaged.emit()
	if type == hit_effect.effect_type.HEAL:
		heal( amount * stat_comp.get_stat(stat_comp.stat_id.IN_HEAL) )

func set_health(new_health: float):
	health = new_health

func heal(amount: float):
	health = min(max_health, health+amount)

func damage(amount: float):
	health -= amount
