extends Resource

class_name Need

var name: String
var current_value: float
var min_value : float 
var max_value: float
var decrease_speed: float
var priority : int

func _init(_name: String, _max_value: float, _decrease_speed: float, _priority : int):
	name = _name
	min_value = 0.0
	max_value = _max_value
	current_value = max_value 
	decrease_speed = _decrease_speed
	priority = _priority

func up_value(value: float)-> void:
	current_value += value
	current_value = clampf(current_value, min_value, max_value)

func down_value(value: float)-> void:
	current_value -= value
	current_value = clampf(current_value, min_value, max_value)
	
func native_decrease(delta: float) -> void:
	current_value -= decrease_speed * delta
	current_value = clampf(current_value, min_value, max_value)
