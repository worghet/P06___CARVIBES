extends VehicleBody3D

@onready var accelerometer_ui = get_parent().get_child(0).get_child(0).get_child(0)

var max_rpm = 500 # max speed
var max_torque = 200 #acceleration

var braking_speed = 3.25

var max_wheel_turn = 0.45 # max wheel turn angle
var steering_speed = 5 # how fast to get to the max wheel turn (2-3 reccomended for chill)

func _process(delta: float) -> void:
	
	# update accelerometer ui
	
	accelerometer_ui.text = "SPEED   //   " + str(linear_velocity.length()).pad_decimals(1)
	steering = lerp(steering, Input.get_axis("right", "left") * max_wheel_turn, delta * steering_speed)
	
	var acceleration = Input.get_axis("backward", "forward") # * 100

	var rpm = $"back-left".get_rpm()
	
	$"back-left".engine_force = acceleration * max_torque * (1-abs(rpm) / max_rpm) # fixed backwards thing w abs
	
	rpm = $"back-right".get_rpm()
	
	$"back-right".engine_force = acceleration * max_torque * (1-abs(rpm) / max_rpm)
	
	
	#dynamic fov
	$camera_pivot/camera.fov = lerp($camera_pivot/camera.fov, 70 + (linear_velocity.length() * 2), 5*delta) # 0 for no dynamic fov
	
	# braking
	if Input.is_action_pressed("brake"): 
		linear_velocity = lerp(linear_velocity, Vector3.ZERO, delta * braking_speed)


func _input(event: InputEvent) -> void:
	pass
	
func _unhandled_input(event: InputEvent) -> void:
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)	
	elif Input.is_action_just_pressed("escape"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)	
			#z
		#) = Input.MOUSE_MODE_CAPTURED
		#
		#print("move cam now")

		
