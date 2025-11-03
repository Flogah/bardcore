extends Node
class_name upgrades_component

var upgrades: Dictionary[int, upgrade] = {}
var stat_upgrades: Dictionary[int, Array] = {}

func add_upgrade(U_ID: int, new_upgrade: upgrade) -> void:
	upgrades[U_ID] = new_upgrade
	if new_upgrade is stat_upgrade:
		var this_stat_upgrades: Array[stat_upgrade] = stat_upgrades[new_upgrade.effected_stat]
		this_stat_upgrades.append(new_upgrade)
		this_stat_upgrades.sort_custom(sort_stat_upgrades_according_to_apply_prio)

func remove_upgrade(U_ID) -> void:
	var upgrade_ = upgrades[U_ID]
	if upgrade_ is stat_upgrade:
		stat_upgrades[upgrade_.effected_stat].erase(upgrade_)
	upgrades.erase(U_ID)

func modify_stat(stat: float, stat_id: stat_component.stat_id) -> float:
	var modifing_upgrades: Array[stat_upgrade] = stat_upgrades[stat_id]
	var modified_stat: float = stat
	if modifing_upgrades is Array:
		for mod_upgrade in modifing_upgrades:
			modified_stat = mod_upgrade.apply(modified_stat)
	return modified_stat

func sort_stat_upgrades_according_to_apply_prio(a: stat_upgrade, b: stat_upgrade) -> bool:
	if a.apply_priority > b.apply_priority:
		return true
	return false
