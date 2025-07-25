extends House

func _init() -> void:
	need_name = "food"

func _ready() -> void:
	name_label.text = "Кафе"
	
func _fill_person(user: Person)-> void:
	for need in user.needs:
		if need.name == need_name:
			need.up_value(speed_of_filling)
			if user.is_need_full(need) == true:
				remove_user(user)
