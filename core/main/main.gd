extends NavigationRegion3D


var speed = 25.0  # скорость движения камеры
var velocity = Vector3.ZERO
@onready var cam : Camera3D = $Camera3D

func _unhandled_input(event: InputEvent) -> void:
	velocity = Vector3.ZERO
	if Input.is_action_pressed("up"):
		velocity.z -= 3
	if Input.is_action_pressed("down"):
		velocity.z += 3
	if Input.is_action_pressed("left"):
		velocity.x -= 3
	if Input.is_action_pressed("right"):
		velocity.x += 3
	if Input.is_action_pressed("zoom+"):
		cam.global_position.y -= 3
	if Input.is_action_pressed("zoom-"):
		cam.global_position.y += 3
	velocity = velocity.normalized()  # для равномерной диагональной скорости

func _process(delta: float) -> void:
	cam.global_position += velocity * speed * delta
