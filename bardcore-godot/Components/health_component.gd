extends Node
class_name health_component


##[/b]This component adds health to its parent. [br][br]
##If you assign this in the [hitbox_component] for it be able to work.[br]
##If you want to telegraph changes, add a [telegraph_component] and assign it here to [member telegraph_comp].[b]

signal died
signal damaged
signal healed

#@export var telegraph_comp: telegraphing_component
@export var stat_comp: stat_component
@export var health_bar: Label
@export_range(10,1000,10) var max_health: float = 100

var regeneration_timer: Timer
var regeneration: bool = false

var health: float
var delay_checks: int = 20

func _ready() -> void:
	regeneration_timer = Timer.new()
	add_child(regeneration_timer)
	health = max_health

func _physics_process(delta: float) -> void:
	
	if health_bar: health_bar.text = str(health)
	
	if health <= 0:
		died.emit()
		
	if delay_checks <= 0: # Check MaxHealth every 20 frames
		check_max_health_change()
		delay_checks = 20
	else:
		delay_checks -= 1
	
	if regeneration:
		handle_regeneration(delta)


func apply(type: hit_effect.effect_type, amount: float):
	#if telegraph_comp: telegraph_comp.display_number(amount, type)
	if type == hit_effect.effect_type.ATTACK:
		damage( amount * stat_comp.get_stat(stat_comp.stat_id.IN_DAMAGE) )
	if type == hit_effect.effect_type.HEAL:
		heal( amount * stat_comp.get_stat(stat_comp.stat_id.IN_HEAL) )

func set_health(new_health: float):
	health = new_health

func heal(amount: float):
	health = min(max_health, health+amount)
	healed.emit()

func damage(amount: float):
	health -= amount
	restart_regeneration_timer()
	damaged.emit()

func check_max_health_change() -> void:
	var stat_max_health = stat_comp.get_stat(stat_comp.stat_id.MAX_HEALTH)
	if stat_max_health != max_health:
		var health_percent = health / max_health
		max_health = stat_max_health
		set_health(max_health * health_percent)

func handle_regeneration(delta: float) -> void:
	heal(stat_comp.get_stat(stat_comp.stat_id.REGENERATION_AMOUNT) * delta)

func restart_regeneration_timer() -> void:
	regeneration_timer.start(stat_comp.get_stat(stat_comp.stat_id.TIME_TILL_REGENERATION))
	regeneration = false
