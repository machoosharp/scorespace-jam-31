extends RigidBody3D


const SPEED = 5.0
const JUMP_VELOCITY = 4.5
var velocity = 0

@onready var camera: Camera3D = $Camera3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _physics_process(delta: float) -> void:

	var space_state = get_world_3d().direct_space_state
	# use global coordinates, not local to node
	var query = PhysicsRayQueryParameters3D.create(Vector3(0, 0, 0), Vector3(0, -2, 0))
	query.collide_with_areas = true
	var result = space_state.intersect_ray(query)
	print(result)
	## Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta

	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")

	var direction := ( Vector3( input_dir.x, 0, input_dir.y ) ).normalized()

	apply_central_impulse( direction*0.1 )
	
	camera.rotation.x = -rotation.x
	camera.rotation.z = -rotation.z
	camera.rotation.y = -rotation.y
