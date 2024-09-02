extends CharacterBody3D


const TERMINAL_VELOCITY = 100

const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var mouse_sens = 0.05
var camera_anglev = 0

const gravity = 10

@onready var ball = $RigidBody3D

@onready var camera = $Camera3D
@onready var pause_menu = $PauseMenu

@onready var ray = $RayCast3D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _unhandled_input( event ):
	if event is InputEventKey and not get_tree().paused:
		if event.pressed and event.keycode == KEY_ESCAPE:
			pause_menu.pause()

func _input( event ):
	if event is InputEventMouseMotion:
		rotate_y( deg_to_rad( -event.relative.x * mouse_sens ) )
		var changev =- event.relative.y * mouse_sens
		if camera_anglev + changev>-45 and camera_anglev + changev<30:
			camera_anglev += changev
			camera.rotate_x( deg_to_rad( changev ) )

func print_vect( v: Vector3 ):
	var xx = snappedf(v.x,0.01)
	if xx == 0:
		xx = '0.00'
	var yy = snappedf(v.y,0.01)
	if yy == 0:
		yy = '0.00'
	var zz = snappedf(v.z,0.01)
	if zz == 0:
		zz = '0.00'
	print("x: ", xx, " y: ", yy, " z: ", zz)

func _physics_process(delta: float) -> void:
	
	var new_up = Vector3.UP.cross(get_floor_normal())
	var new_down = Vector3.DOWN.cross(get_floor_normal())

	velocity.y = move_toward(velocity.y, -TERMINAL_VELOCITY, gravity * delta)

	ray.global_rotation = new_up
	
	print_vect(ray.global_rotation)

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	var direction := ( transform.basis * Vector3( input_dir.x, 0, input_dir.y ) ).normalized()

	var asdf = new_up.rotated(Vector3.UP, deg_to_rad(-90.0))

	if direction:
		velocity.x = move_toward(velocity.x, direction.x * SPEED, SPEED * delta)
		velocity.z = move_toward(velocity.z, direction.z * SPEED, SPEED * delta)

	else:
		velocity.x = move_toward(velocity.x, asdf.x * SPEED, SPEED * delta)
		velocity.z = move_toward(velocity.z, asdf.z * SPEED, SPEED * delta)

	var diff: Vector3 = ( global_position - ball.global_position )

	ball.apply_central_impulse(diff * 3)

	#print_vect(velocity)

	move_and_slide()
