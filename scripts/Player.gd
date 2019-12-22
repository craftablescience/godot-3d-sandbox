extends KinematicBody


export var SPEED_RUN := 16.0
export var SPEED := 8.0
export var SPEED_WALK := 4.0
export var SPEED_CROUCH := 1
export var SPEED_JUMP := 16.0
export var SENSITIVITY := 0.1

var gravity := Vector3.DOWN * 32.0
var velocity := Vector3()
var spin := 0.1
var can_jump := false

var camera : Camera
var rotation_helper : Spatial

var ENABLED : bool = true
var AVAILABLE_INPUT : bool = false

func _ready() -> void:
	camera = $RotationHelper/Camera
	rotation_helper = $RotationHelper
	
	camera.current = true

func set_pos(v : Vector3) -> void:
	self.translation = v

func set_vel(v : Vector3) -> void:
	self.velocity = v

func get_pos() -> Vector3:
	return self.translation

func get_movement_input() -> void:
	if ENABLED:
		var speed : float
		if Input.is_action_pressed("movement_crouch"):
			speed = SPEED_CROUCH
		elif Input.is_action_pressed("movement_walk"):
			speed = SPEED_WALK
		elif Input.is_action_pressed("movement_run"):
			speed = SPEED_RUN
		else:
			speed = SPEED
		
		var vy := velocity.y
		velocity = Vector3()
		if Input.is_action_pressed("movement_up"):
			velocity += (-transform.basis.z * speed)
		if Input.is_action_pressed("movement_down"):
			velocity += (transform.basis.z * speed)
		if Input.is_action_pressed("movement_left"):
			velocity += (-transform.basis.x * speed)
		if Input.is_action_pressed("movement_right"):
			velocity += (transform.basis.x * speed)
		velocity.y = vy
		
		can_jump = false
		if Input.is_action_just_pressed("movement_jump"):
			can_jump = true
	else:
		velocity = Vector3()

func _process(delta : float) -> void:
	if AVAILABLE_INPUT:
		if Input.is_action_just_pressed("movement_interact"):
			ENABLED = not ENABLED
	
	"""
	if not ENABLED:
		$CollisionShape.disabled = true
		$CollisionShape2.disabled = true
	else:
		$CollisionShape.disabled = false
		$CollisionShape2.disabled = false
	"""
	$UI_Debug/Label.text = "ENABLED = " + str(ENABLED)
	$UI_Debug/Label2.text = "AVAILABLE_INPUT = " + str(AVAILABLE_INPUT)
	$UI_Debug/Label3.text = "FPS = " + str(Engine.get_frames_per_second())

func _physics_process(delta : float) -> void:
	
	get_movement_input()
	
	if ENABLED:
		velocity += gravity * delta
		velocity = move_and_slide(velocity, Vector3.UP, false, 4, PI/4, false)
	
		if can_jump and is_on_floor():
			velocity.y = SPEED_JUMP

func _input(event) -> void:
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotation_helper.rotate_x(deg2rad(event.relative.y * SENSITIVITY * -1))
		self.rotate_y(deg2rad(event.relative.x * SENSITIVITY * -1))
		var camera_rot := rotation_helper.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -90, 90)
		rotation_helper.rotation_degrees = camera_rot

func set_available_input(b : bool) -> void:
	AVAILABLE_INPUT = b