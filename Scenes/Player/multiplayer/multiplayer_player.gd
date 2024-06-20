extends CharacterBody3D
class_name OnlinePlayer

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
const SENSITIVITY = 0.01

const BOB_FREQ = 2.0
const BOB_AMP = 0.08
var t_bob = 0.0

var owner_id = 1

@onready var head: Node3D = $Head
@onready var camera: Camera3D = $Head/Camera3D

@export var player_id := 1

func _enter_tree() -> void:
	owner_id = name.to_int()
	set_multiplayer_authority(owner_id)

func _ready():
	if owner_id == multiplayer.get_unique_id():
		%Camera3D.make_current()
	else:
		%Camera3D.current = false
	
func _input(event: InputEvent) -> void:
	if owner_id != multiplayer.get_unique_id():
		return
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * SENSITIVITY)
		camera.rotate_x(-event.relative.y * SENSITIVITY)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-40),deg_to_rad(60))

func _physics_process(delta: float) -> void:
	if owner_id != multiplayer.get_unique_id():
		return
	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("left", "right", "forward", "backward")
	var direction := (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = 0
		velocity.z = 0
	t_bob += delta * velocity.length() * float(is_on_floor())
	camera.transform.origin = _headbob(t_bob)
	move_and_slide()

func _headbob(time) -> Vector3:
	var pos = Vector3.ZERO
	
	pos.y = sin(time * BOB_FREQ) * BOB_AMP
	
	return pos
