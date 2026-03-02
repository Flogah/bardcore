extends Node
class_name stat_component

var baseStats: BaseStats

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
	IN_DAMAGE, #Modifier applied on all negative health changes (hits, status-effect damage, ...)
	
	# -- Combat Stats --
	OUT_HEAL, #Modifier applied on all outgoing heals
	OUT_DAMAGE, #Modifier applied on all outgoing damaging hits
	ARMOR, #Multiplied with the damage after accounting for armor-piercing
	ARMOR_PIERCING, #Removed form armor of hits target
	RANGE, #Multiplies the leangth of the instruments area
	ANGLE, #Multiplies the angle of the instruments area
	
	# -- Item Slot Stats --
	HELMET_SLOTS,
	TORSO_SLOTS,
	BOOTS_SLOTS,
	RING_SLOTS,
}

var upgrades: Dictionary[stat_id, Array] = {} # Contains all item_ids as keys and point to an array with all upgrades from that item
var stat_upgrades: Dictionary[stat_id, Array] = {} # Contains all stat_ids as keys and they point onto an array with all upgrades that effect the key-stat

var stats: Dictionary[stat_id, stat] = { #Contains Stat_id: int -> stat_object: stat

}

func _ready() -> void:
	for key in BaseStats.stats.keys():
		var stat_object: stat = stat.new()
		stat_object.base = BaseStats.get_base_stat(key)
		stat_object.modified = BaseStats.get_base_stat(key)
		stats[key] = stat_object
		stat_upgrades[key] =  []

func get_stat(s_id: stat_id) -> float:
	var requested_stat: stat = stats[s_id]
	if requested_stat:
		if requested_stat.dynamic:
			calculate_stat(requested_stat, s_id)
		return requested_stat.modified
	else:
		push_warning("There was no stat with stat_id: "+str(s_id)+"! A float with amount 1.0 was returned instead.")
		return 1.0

func get_stat_object(s_id: stat_id) -> stat:
	var requested_stat: stat = stats[s_id]
	if requested_stat:
		return requested_stat
	return null

func add_upgrades(Item_ID: int, new_upgrades: Array[upgrade]) -> void:
	upgrades[Item_ID] = new_upgrades
	var stats_upgrades_changed: Dictionary[stat_id, float]
	for new_upgrade in new_upgrades:
		if new_upgrade is stat_upgrade:
			stats_upgrades_changed[new_upgrade.effected_stat] = 0
			var this_stats_upgrades = stat_upgrades[new_upgrade.effected_stat]
			this_stats_upgrades.append(new_upgrade)
			this_stats_upgrades.sort_custom(sort_stat_upgrades_according_to_apply_prio)
		if new_upgrade is triggered_upgrade:
			new_upgrade.connect_trigger()
		recalculate_stats(stats_upgrades_changed)

func remove_upgrades(Item_ID) -> void:
	if Item_ID not in upgrades.keys():
		return
	
	var old_upgrades: Array[upgrade] = upgrades[Item_ID]
	var stats_upgrades_changed: Dictionary[stat_id, float]
	for old_upgrade in old_upgrades:
		if old_upgrade is stat_upgrade:
			stat_upgrades[old_upgrade.effected_stat].erase(old_upgrade)
			stats_upgrades_changed[old_upgrade.effected_stat] = 0
		if old_upgrade is triggered_upgrade:
			old_upgrade.disconnect_trigger()
	if stats_upgrades_changed.keys().size() > 0:
		recalculate_stats(stats_upgrades_changed)
	upgrades.erase(Item_ID)

func calculate_stat(stat_object: stat, s_id: stat_id) -> void:
	var stat_value = stat_object.base
	if s_id in stat_upgrades.keys():
		var modifing_upgrades = stat_upgrades[s_id]
		if modifing_upgrades is Array:
			for mod_upgrade in modifing_upgrades:
				stat_value = mod_upgrade.apply(stat_value)
				if mod_upgrade.dynamic: stat_object.dynamic = true
	stat_object.change_stat(stat_value)

func sort_stat_upgrades_according_to_apply_prio(a: stat_upgrade, b: stat_upgrade) -> bool:
	if a.apply_priority > b.apply_priority:
		return true
	return false

func recalculate_stats(s_ids: Dictionary[stat_id, float]) -> void:
	for s_id in s_ids.keys():
		calculate_stat(stats[s_id], s_id)

func set_base_stats(bard_type: PlayerManager.bard_type) -> void:
	var bte = PlayerManager.bard_type
	if bard_type == bte.lover: baseStats = load("res://Resources/Stats/lover.tres")
	elif bard_type == bte.relic: baseStats = load("res://Resources/Stats/relic.tres")
	elif bard_type == bte.star: baseStats = load("res://Resources/Stats/star.tres")
	for stat_id_ in baseStats.stats.keys():
		var base_stat: float = baseStats.stats[stat_id_]
		var base_stat_multiplier: float = 1.0
		if stat_id_ in baseStats.base_stat_multipliers.keys():
			base_stat_multiplier = baseStats.base_stat_multipliers[stat_id_]
		stats[stat_id_].change_base_stat(base_stat * base_stat_multiplier)
	recalculate_stats(baseStats.stats) #recalculate all stats
