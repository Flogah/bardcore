extends upgrade
class_name stat_upgrade

@export var effected_stat: int
@export var apply_priority: int

func apply(stat: float) -> float:
		return 1.0
