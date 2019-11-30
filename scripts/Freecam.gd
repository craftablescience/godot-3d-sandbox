extends Spatial


export var SPEED_RUN := 0.4
export var SPEED := 0.2
export var SPEED_WALK := 0.1
export var SPEED_CROUCH := 0.025
export var SENSITIVITY := 0.1

var velocity = Vector3()
var camera
var rotation_helper


func _ready():
	camera = $RotationHelper/Camera
	rotation_helper = $RotationHelper

func get_movement_input():
	var speed
	if Input.is_action_pressed("camera_ydown"):
		speed = SPEED_CROUCH
	elif Input.is_action_pressed("movement_walk"):
		speed = SPEED_WALK
	elif Input.is_action_pressed("movement_run"):
		speed = SPEED_RUN
	else:
		speed = SPEED
	
	velocity = Vector3()
	if Input.is_action_pressed("movement_up"):
		velocity += (-camera.transform.basis.z * speed)
	if Input.is_action_pressed("movement_down"):
		velocity += (camera.transform.basis.z * speed)
	if Input.is_action_pressed("movement_left"):
		velocity += (-camera.transform.basis.x * speed)
	if Input.is_action_pressed("movement_right"):
		velocity += (camera.transform.basis.x * speed)
	if Input.is_action_pressed("movement_jump"):
		velocity.y += speed
	elif Input.is_action_pressed("movement_crouch"):
		velocity.y -= speed
	else:
		velocity.y = 0

func _process(delta):
	get_movement_input()
	translate(velocity)

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		rotation_helper.rotate_x(deg2rad(event.relative.y * SENSITIVITY * -1))
		self.rotate_y(deg2rad(event.relative.x * SENSITIVITY * -1))

		var camera_rot = rotation_helper.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -70, 70)
		rotation_helper.rotation_degrees = camera_rot