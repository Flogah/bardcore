extends Node
class_name upgrades_component

var upgrades: Dictionary[int, Array] = {}
var stat_upgrades: Dictionary[int, Array] = {}

func add_upgrades(Item_ID: int, new_upgrades: Array[upgrade]) -> void:
	upgrades[Item_ID] = new_upgrades
	for new_upgrade in new_upgrades:
		if new_upgrade is stat_upgrade:
			var this_stats_upgrades: Array[stat_upgrade] = stat_upgrades[new_upgrade.effected_stat]
			this_stats_upgrades.append(new_upgrade)
			this_stats_upgrades.sort_custom(sort_stat_upgrades_according_to_apply_prio)
		if new_upgrade is triggered_upgrade:
			new_upgrade.connect_trigger()

func remove_upgrades(Item_ID) -> void:
	var old_upgrades: Array[upgrade] = upgrades[Item_ID]
	for old_upgrade in old_upgrades:
		if old_upgrade is stat_upgrade:
			stat_upgrades[old_upgrade.effected_stat].erase(old_upgrade)
		if old_upgrade is triggered_upgrade:
			old_upgrade.disconnect_trigger()
	upgrades.erase(Item_ID)

func modify_stat(stat: float, stat_id: stat_component.stat_id) -> float:
	var modified_stat: float = stat
	if stat_id in stat_upgrades.keys():
		var modifing_upgrades: Array[stat_upgrade] = stat_upgrades[stat_id]
		if modifing_upgrades is Array:
			for mod_upgrade in modifing_upgrades:
				modified_stat = mod_upgrade.apply(modified_stat)
	return modified_stat

func sort_stat_upgrades_according_to_apply_prio(a: stat_upgrade, b: stat_upgrade) -> bool:
	if a.apply_priority > b.apply_priority:
		return true
	return false
