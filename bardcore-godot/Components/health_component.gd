extends Node
class_name health_component


##[/b]This component adds health to its parent. [br][br]
##If you assign this in the [hitbox_component] for it be able to work.[br]
##If you want to telegraph changes, add a [telegraph_component] and assign it here to [member telegraph_comp].[b]

signal died
signal damaged(amount: float, mod_amount:float, total:float)
signal healed(amount:float, mod_amount:float, total:float)

@export var telegraph_comp: telegraphing_component
@export var stat_comp: stat_component
@export_range(10,1000,10) var max_health: float = 100

var health: float

var time_till_regeneration_timer: Timer
var regeneration_tick_timer: Timer

func _ready() -> void:
	health = max_health
	
	regeneration_tick_timer = Timer.new()
	regeneration_tick_timer.one_shot = false
	regeneration_tick_timer.name = "regeneration_tick_timer"
	regeneration_tick_timer.wait_time = 1
	regeneration_tick_timer.timeout.connect(regenerate)
	add_child(regeneration_tick_timer)
	
	time_till_regeneration_timer = Timer.new()
	time_till_regeneration_timer.one_shot = true
	time_till_regeneration_timer.name = "time_till_regeneration_timer"
	stat_comp.get_stat_object(stat_comp.stat_id.TIME_TILL_REGENERATION).changed.connect(update_time_till_regeneration_timer)
	update_time_till_regeneration_timer()
	time_till_regeneration_timer.timeout.connect(regeneration_tick_timer.start)
	add_child(time_till_regeneration_timer)
	

func apply(type: hit_effect.effect_type, amount: float):
	if telegraph_comp: telegraph_comp.display_number(amount, type)
	if type == hit_effect.effect_type.ATTACK:
		damage(amount)
	if type == hit_effect.effect_type.HEAL:
		heal(amount)

func set_health(new_health: float):
	health = new_health

func heal(amount: float):
	var modified_amount: float = min(max_health, health+amount*stat_comp.get_stat(stat_comp.stat_id.IN_HEAL))
	health = modified_amount
	healed.emit(amount, modified_amount, health)
	if health >= max_health: 
		regeneration_tick_timer.stop()
		time_till_regeneration_timer.stop()

func damage(amount: float):
	regeneration_tick_timer.stop()
	time_till_regeneration_timer.start()
	var modified_amount: float = amount * exp(-0.02 * stat_comp.get_stat(stat_comp.stat_id.ARMOR)) * stat_comp.get_stat(stat_comp.stat_id.IN_DAMAGE)
	health -= modified_amount
	damaged.emit(amount, modified_amount, health)
	if health <= 0:
		
		health = 0
		died.emit()

func update_time_till_regeneration_timer() -> void:
	time_till_regeneration_timer.wait_time = stat_comp.get_stat(stat_comp.stat_id.TIME_TILL_REGENERATION)

func regenerate() -> void:
	heal(stat_comp.get_stat(stat_comp.stat_id.REGENERATION_AMOUNT))
