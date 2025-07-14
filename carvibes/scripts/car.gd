extends VehicleBody3D

var max_rpm = 500
var max_torque = 200


var max_wheel_turn = 0.45 # max wheel turn angle
var steering_speed = 5 # how fast to get to the max wheel turn

func _process(delta: float) -> void:
	steering = lerp(steering, Input.get_axis("right", "left") * max_wheel_turn, delta * steering_speed)
	
	var acceleration = Input.get_axis("backward", "forward") # * 100

	var rpm = $"back-left".get_rpm()
	
	$"back-left".engine_force = acceleration * max_torque * (1-rpm / max_rpm)
	
	rpm = $"back-right".get_rpm()
	
	$"back-right".engine_force = acceleration * max_torque * (1-rpm / max_rpm)
	
	#if Input.is_action_pressed("brake"): 
		#linear_velocity = linear_velocity.linear_interpolate(Vector3.ZERO, 5 * delta)


func _input(event: InputEvent) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)	
	elif Input.is_action_just_pressed("escape"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)	
			#
		#) = Input.MOUSE_MODE_CAPTURED
		#
		#print("move cam now")

		
	
	get_parent().get_child(0).get_child(0).get_child(0).text = "SPEED   //   " + str(linear_velocity.length()).pad_decimals(1)
