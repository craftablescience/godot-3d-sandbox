extends VehicleBody


############################################################
# behaviour values

export var MAX_ENGINE_FORCE : float = 200.0
export var MAX_BRAKE_FORCE : float = 10.0
export var MAX_STEER_ANGLE : float = 0.5

export var steer_speed : float = 5.0

var steer_target : float = 0.0
var steer_angle : float = 0.0

var steer_val : float
var throttle_val : float
var brake_val : float

############################################################
# Joystick Input

#export var joy_steering = JOY_ANALOG_LX
#export var steering_mult : float = -1.0
#export var joy_throttle = JOY_ANALOG_R2
#export var throttle_mult : float = 1.0
#export var joy_brake = JOY_ANALOG_L2
#export var brake_mult : float = 1.0

var ENABLED : bool = false
var PLAYER_IN_CAB : bool = false

func enter() -> void:
	ENABLED = true

func leave() -> void:
	ENABLED = false

func _process(delta : float) -> void:
	if Input.is_action_just_pressed("movement_interact"):
		if PLAYER_IN_CAB:
			ENABLED = not ENABLED

func _physics_process(delta : float) -> void:
	#var steer_val = steering_mult * Input.get_joy_axis(0, joy_steering)
	#var throttle_val = throttle_mult * Input.get_joy_axis(0, joy_throttle)
	#var brake_val = brake_mult * Input.get_joy_axis(0, joy_brake)
	
	if ENABLED:
		# overrules for keyboard
		if Input.is_action_pressed("movement_up"):
			throttle_val = 1.0
		else:
			throttle_val = 0.0
		
		if Input.is_action_pressed("movement_down"):
			brake_val = 1.0
		else:
			brake_val = 0.0
		
		if (Input.is_action_pressed("movement_left") and (not Input.is_action_pressed("movement_right"))):
			steer_val = 1.0
		if (Input.is_action_pressed("movement_right") and (not Input.is_action_pressed("movement_left"))):
			steer_val = -1.0
		if not (Input.is_action_pressed("movement_left") or Input.is_action_pressed("movement_right")):
			steer_val = 0.0
		
		engine_force = throttle_val * MAX_ENGINE_FORCE
		brake = brake_val * MAX_BRAKE_FORCE
		
		steer_target = steer_val * MAX_STEER_ANGLE
		if (steer_target < steer_angle):
			steer_angle -= steer_speed * delta
			if (steer_target > steer_angle):
				steer_angle = steer_target
		elif (steer_target > steer_angle):
			steer_angle += steer_speed * delta
			if (steer_target < steer_angle):
				steer_angle = steer_target
		
		steering = steer_angle
	else:
		brake = brake_val * MAX_BRAKE_FORCE / 2
		steering = 0.0
		engine_force = 0.0

func _on_PlayerButton_body_entered(body : Node):
	if body.is_in_group("Players"):
		(body as KinematicBody).set_available_input(true)
		PLAYER_IN_CAB = true

func _on_PlayerButton_body_exited(body : Node):
	if body.is_in_group("Players"):
		(body as KinematicBody).set_available_input(false)
		PLAYER_IN_CAB = false