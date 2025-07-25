extends CharacterBody3D

class_name Person

enum States {IDLE, MOVING, USING}
var state: States = States.IDLE

var speed: float = 10.0
var target_house : House = null

var needs: Array[Need] = [
	Sleep_need.new(),
	Food_need.new(),
	Fun_need.new()
]
@onready var sleep_label : Label3D = $SleepIcon/Label3D
@onready var food_label : Label3D = $FoodIcon/Label3D
@onready var fun_label : Label3D = $FunIcon/Label3D

@onready var mesh : MeshInstance3D = $MeshInstance3D
@onready var agent : NavigationAgent3D = $NavigationAgent3D

func _ready() -> void:
	#Добавил для тестов, задаёт случайные значения всем потребностям
	for i in needs:
		i.current_value = Global.rng.randf_range(0, 100)
	

func _physics_process(delta: float) -> void:
	_update_needs(delta)
	match state:
		States.IDLE:
			_choose_next_action()
		States.MOVING:
			_moving(delta)
		States.USING:
			return

func _choose_next_action()-> void:
	if needs.is_empty():
			return
	var most_important_need_type = _get_most_important_need_type()
	target_house = _find_house(most_important_need_type)
	if target_house:
		move_to(target_house.entry_pos.global_transform.origin)

func move_to(target_position: Vector3) -> void:
	agent.set_target_position(target_position)
	state = States.MOVING

func _moving(delta: float)-> void:
	if agent.is_navigation_finished():
		velocity = Vector3.ZERO
		if target_house != null:
			target_house.add_user(self)
			state = States.USING
	else:
		var next_path_position: Vector3 = agent.get_next_path_position()
		var direction: Vector3 = (next_path_position - global_transform.origin).normalized()
		velocity = direction * speed
	move_and_slide()

func _find_house(need_type : String)-> House:
	var group_name = need_type+ "_house" 
	var houses = get_tree().get_nodes_in_group(group_name)
	
	if houses.is_empty():
		print_debug("Нет домов в группе - ", group_name)
		return
		
	var best_house = houses[0]
	var min_queue = best_house.get_queue_size()
	var min_distance = best_house.global_transform.origin.distance_to(global_position)
	
	for house in houses:
		var queue_size = house.get_queue_size()
		var distance = house.global_position.distance_to(global_position)

		if queue_size < min_queue:
			best_house = house
			min_queue = queue_size
			min_distance = distance
		elif queue_size == min_queue and distance < min_distance:
			best_house = house
			min_distance = distance
	return best_house

func _get_most_important_need_type():
	var best_need = null
	for need in needs:
		if best_need == null:
			best_need = need
		else:
			if need.current_value < best_need.current_value:
				best_need = need
			elif need.current_value == best_need.current_value and need.priority < best_need.priority:
				best_need = need
	return best_need.name

func _update_needs(delta: float)-> void:
	for need in needs:
		need.native_decrease(delta)
	UI_update()

func UI_update() -> void:
	sleep_label.text = str(int(needs[0].current_value))
	food_label.text = str(int(needs[1].current_value))
	fun_label.text = str(int(needs[2].current_value))
	
func start_filling() -> void:
	state = States.USING

func is_need_full(need : Need)-> bool:
	if need.current_value >= need.max_value:
		return true
	else:	
		return false


func end_filling()-> void:
	target_house = null
	state = States.IDLE
	#Отойти в другую точку
	#move_to(Vector3(Global.rng.randi_range(-15,15),Global.rng.randi_range(-15,15),Global.rng.randi_range(-15,15)))

#func _on_timer_timeout() -> void:
	#print("потребности :")
	#for i in needs:
		#print(i.current_value)
	#print("Состояние = ", state)
