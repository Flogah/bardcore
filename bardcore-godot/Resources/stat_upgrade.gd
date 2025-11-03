extends upgrade
class_name stat_upgrade

@export var effected_stat: stat_component.stat_id
@export var apply_priority: int

func apply(stat: float) -> float:
		return 1.0
