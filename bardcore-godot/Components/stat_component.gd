extends Node
class_name stat_component

enum stat_id {
	
	# -- Movement Stats --
	MOVEMENT_SPEED, #Maximum Move Speed
	MOVEMENT_ACCELERATION, #Amount of Acceleration
	
	# -- Health Stats --
	MAX_HEALTH, #Maximum Amount of Health
	TIME_TILL_REGENERATION, #Seconds till Regeneration starts after last hit
	REGENERATION_AMOUNT, #Regeneration per delta time
	IN_HEAL, #Modifier applied on all incoming heals
	HEALTH_GAIN, #Modifier applied on all positive health changes (incoming heals, regeneration, ...)
	INCOMING_DAMAGE, #Modifier applied on all negative health changes (hits, status-effect damage, ...)
	
	# -- Combat Stats --
	OUT_HEAL, #Modifier applied on all outgoing heals
	OUT_DAMAGE, #Modifier applied on all outgoing damaging hits
	ARMOR, #Multiplied with the damage after accounting for armor-piercing
	ARMOR_PIERCING, #Removed form armor of hits target
	RANGE, #Multiplies the leangth of the instruments area
	ANGLE, #Multiplies the angle of the instruments area
	
}

@export var upgrade_comp: upgrades_component
@export var stats: Dictionary[stat_id, float] = {
	
	# -- Movement Stats --
	stat_id.MOVEMENT_SPEED: 5.0, #Maximum Move Speed
	stat_id.MOVEMENT_ACCELERATION: 0.5, #Amount of Acceleration
	
	# -- Health Stats --
	stat_id.MAX_HEALTH: 100.0, #Maximum Amount of Health
	stat_id.TIME_TILL_REGENERATION: 2.5, #Seconds till Regeneration starts after last hit
	stat_id.REGENERATION_AMOUNT: 5.0, #Regeneration per delta time
	stat_id.IN_HEAL: 1.0, #Modifier applied on all incoming heals
	stat_id.HEALTH_GAIN: 1.0, #Modifier applied on all positive health changes (incoming heals, regeneration, ...)
	stat_id.INCOMING_DAMAGE: 1.0, #Modifier applied on all negative health changes (hits, status-effect damage, ...)
	
	# -- Combat Stats --
	stat_id.OUT_HEAL: 1.0, #Modifier applied on all outgoing heals
	stat_id.OUT_DAMAGE: 1.0, #Modifier applied on all outgoing damaging hits
	stat_id.ARMOR: 1.0, #Multiplied with the damage after accounting for armor-piercing
	stat_id.ARMOR_PIERCING: 0.0, #Removed form armor of hits target
	stat_id.RANGE: 1.0, #Multiplies the leangth of the instruments area
	stat_id.ANGLE: 1.0, #Multiplies the angle of the instruments area
	
}

func get_stat(s_id: stat_id) -> float:
	var modified_stat: float = stats[s_id]
	if modified_stat:
		if upgrade_comp:
			modified_stat = upgrade_comp.modify_stat(modified_stat, s_id)
		return modified_stat
	else:
		push_warning("There was no stat with stat_id: "+str(s_id)+"! A float with amount 1.0 was returned instead.")
		return 1.0
