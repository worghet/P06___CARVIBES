extends VehicleBody3D

@onready var accelerometer_ui : Label = get_parent().get_child(0).get_child(0).get_child(0)

var max_rpm = 500 # max speed
var max_torque = 500 #power

var braking_speed = 5

var max_wheel_turn = deg_to_rad(22.5) # max wheel turn angle
var steering_speed = 2.75 # how fast to get to the max wheel turn (2-3 reccomended for chill)
# maybe make speed a curve

var dynamic_fov_scale = 2



var is_drifting = false

var should_reset = false

func _process(delta: float) -> void:
	
	# update accelerometer ui
	
	accelerometer_ui.text = "SPEED   //   " + str(linear_velocity.length()).pad_decimals(1)
	
	
	
	steering = lerp(steering, Input.get_axis("left", "right") * max_wheel_turn, delta * steering_speed)
	
	var acceleration = Input.get_axis("backward", "forward") # * 100

	var rpm = $"back-left".get_rpm()
	
	$"back-left".engine_force = acceleration * max_torque * (1-abs(rpm) / max_rpm) # fixed backwards thing w abs
	#$"back-left".engine_force = $"front-left".engine_force * 2
	
	
	rpm = $"back-right".get_rpm()
	
	$"back-right".engine_force = acceleration * max_torque * (1-abs(rpm) / max_rpm)
	#$"back-right".engine_force = $"front-right".engine_force * 2
	
	#dynamic fov
	$camera_pivot/camera.fov = lerp($camera_pivot/camera.fov, 70 + (linear_velocity.length() * dynamic_fov_scale), 5*delta) # 0 for no dynamic fov
	
	# braking
	if Input.is_action_pressed("brake"): 
		#bug: will also keep the car floating if in the air..
		linear_velocity = lerp(linear_velocity, Vector3.ZERO, delta * braking_speed)
		
		
	if is_drifting:
		#engine force is recalculated all the time
		$"back-right".engine_force *= 5
		$"back-left".engine_force *= 5
	


func _input(event: InputEvent) -> void:
	
	# activate flag
	if Input.is_action_just_pressed("reset_car"):
		should_reset = true
		
	if Input.is_action_pressed("drift"):
		is_drifting = true
	else:
		is_drifting = false
		
		
func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	if should_reset:
		should_reset = false

		# lift car 2 units
		var new_position = state.transform.origin + Vector3.UP * 2.0

		# calculate upright basis (orientation)
		var up = Vector3.UP
		var forward = state.transform.basis.z.normalized()

		# Avoid forward being too close to up to prevent gimbal issues
		if abs(forward.dot(up)) > 0.99:
			forward = -state.transform.basis.x.normalized()

		var right = up.cross(forward).normalized()
		forward = right.cross(up).normalized()

		var new_basis = Basis(right, up, forward)
		var new_transform = Transform3D(new_basis, new_position)

		# apply new tranformation
		state.transform = new_transform


		# will reset speeds (commented: gives a cool effect)
		#linear_velocity = Vector3.ZERO
		#angular_velocity = Vector3.ZERO

	
	

		
