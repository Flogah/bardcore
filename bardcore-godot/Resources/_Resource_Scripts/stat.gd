extends Object
class_name stat

signal changed

var base: float = 1.0
var modified: float = 1.0
var dynamic: bool = false

func change_stat(new_value: float) -> void:
	modified = new_value
	changed.emit()

func change_base_stat(new_value: float) -> void:
	base = new_value
