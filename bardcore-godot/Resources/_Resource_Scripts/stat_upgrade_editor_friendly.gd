extends stat_upgrade
class_name stat_upgrade_editor

@export var amount: float
@export_enum("Multiply", "Add") var operator: int

func apply(stat_value: float) -> float:
	if operator == 0:
		return stat_value * amount
	else:
		return stat_value + amount
