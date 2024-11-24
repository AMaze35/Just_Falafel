extends CharacterBody3D

# Player Movement

const SPEED = 5.0
const SPRINT = 7.5
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.75

var current = SPEED

@onready var head := $head
@onready var camera := $head/Camera3D

# First Person Mouse Control
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	elif event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		if event is InputEventMouseMotion:
			head.rotate_y(-event.relative.x * 0.01)
			camera.rotate_x(-event.relative.y * 0.01)
			camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-70), deg_to_rad(90))

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	# First Person Control using Controller
	if Input.is_action_pressed("look_up"):
		if head.rotation.x <= 1:
			head.rotation.x += 5.0 * delta
	if Input.is_action_pressed("look_down"):
		if head.rotation.x >= -1:
			head.rotation.x -= 5.0 * delta
	if Input.is_action_pressed("look_right"):
		head.rotation.y -= 0.1
	if Input.is_action_pressed("look_left"):
		head.rotation.y += 0.1
		
	if Input.is_action_pressed("sprint") and is_on_floor():
		current = SPRINT
	else:
		current = SPEED

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * current
		velocity.z = direction.z * current
	else:
		velocity.x = 0.0
		velocity.z = 0.0
		

	move_and_slide()
