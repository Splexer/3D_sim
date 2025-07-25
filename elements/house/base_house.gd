extends StaticBody3D

class_name House

@export var capacity : int = 1
@export var speed_of_filling : float = 1

var users : Array[Person] = []
var need_name : String

@onready var current_capacity_label : Label3D = $Label3D/current_capacity_label
@onready var all_capacity_label : Label3D = $Label3D/all_capacity_label
@onready var name_label : Label3D = $name_label
@onready var entry_pos : Area3D = $entry_pos


func add_user(user : Person)-> void:
	if users.has(user):
		return
	users.append(user)
	user.move_to(get_queue_position(users.size() - 1))
	user.start_filling()
	_queue_update()

func remove_user(user : Person)-> void:
	user.end_filling()
	users.erase(user)
	_queue_update()

func _update() -> void:
	UI_update()
	if users.is_empty() == true:
		return
	var count = min(capacity, users.size())	
	var active_users = users.slice(0, count, true)
	for user in active_users:
		_fill_person(user)

func _fill_person(user: Person)-> void:
	pass

func _queue_update()-> void:
	for i in range(users.size()):
		users[i].move_to(get_queue_position(i))

func get_queue_position(queue_index: int) -> Vector3:
	var queue_pos = entry_pos.global_transform.origin + entry_pos.global_transform.basis.z.normalized() * (queue_index + 2)
	return queue_pos

func get_queue_size()-> int:
	var queue = users.size() - capacity
	if queue <= 0:
		return 0
	else: 
		return queue

func UI_update()-> void:
	all_capacity_label.text = str(capacity)
	if users.size() > capacity:
		current_capacity_label.text = str(capacity) + " / "
	else:
		current_capacity_label.text = str(users.size()) + " / "

func _on_timer_timeout() -> void:
	_update()
