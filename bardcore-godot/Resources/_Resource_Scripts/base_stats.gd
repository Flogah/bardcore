extends Resource
class_name BaseStats

static var se = stat_component.stat_id
static var stats: Dictionary[stat_component.stat_id, float] = {
	# -- Movement Stats --
	se.MOVEMENT_SPEED: 500.0, #Maximum Move Speed
	se.MOVEMENT_ACCELERATION: 0.5, #Amount of Acceleration
	
	# -- Health Stats --
	se.MAX_HEALTH: 100.0, #Maximum Amount of Health
	se.TIME_TILL_REGENERATION: 2.5, #Seconds till Regeneration starts after last hit
	se.REGENERATION_AMOUNT: 5.0, #Regeneration per second
	se.IN_HEAL: 1.0, #Modifier applied on all incoming heals
	se.HEALTH_GAIN: 1.0, #Modifier applied on all positive health changes (incoming heals, regeneration, ...)
	se.IN_DAMAGE: 1.0, #Modifier applied on all negative health changes (hits, status-effect damage, ...)
	
	# -- Combat Stats --
	se.OUT_HEAL: 1.0, #Modifier applied on all outgoing heals
	se.OUT_DAMAGE: 20.0, #Modifier applied on all outgoing damaging hits
	se.ARMOR: 1.0, #Multiplied with the damage after accounting for armor-piercing
	se.ARMOR_PIERCING: 0.0, #Removed form armor of hits target
	se.RANGE: 1.0, #Multiplies the leangth of the instruments area
	se.ANGLE: 1.0, #Multiplies the angle of the instruments area
	
	# -- Inventory Stats --
	se.HELMET_SLOTS: 1.0,
	se.TORSO_SLOTS: 1.0,
	se.BOOTS_SLOTS: 1.0,
	se.RING_SLOTS: 2.0,
}

@export var base_stat_multipliers: Dictionary[stat_component.stat_id, float]

func get_modified_base_stat(stat_id: stat_component.stat_id) -> float:
	return stats[stat_id] * base_stat_multipliers[stat_id]

static func get_base_stat(stat_id: stat_component.stat_id) -> float:
	return stats[stat_id]
