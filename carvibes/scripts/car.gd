extends VehicleBody3D



# Script deals with the car controlling.


# ================================================================
# == VARIABLES ===================================================
# ================================================================



# Reference to the ui that shows carspeed.
@onready var accelerometer_ui : Label = get_parent().get_child(0).get_child(0).get_child(0)

# Convenient references for readability.
@onready var back_left_wheel : Node = $"back_left"
@onready var back_right_wheel : Node = $"back_right"
@onready var camera : Node = $camera_pivot/camera

# Constants for dictating behaviour.
const max_rpm : int = 500 # max speed
const max_torque : float = 500 #power
const braking_speed : float = 5
const max_wheel_turn : float = deg_to_rad(22.5) # max wheel turn angle
const steering_speed : float = 2.75 # how fast to get to the max wheel turn (2-3 reccomended for chill)

# Action flag.
var should_reset : bool = false

# User-controlled modifiers.
@export var dynamic_fov_scale : float = 2 # 0 for no dynamic fov



# ================================================================
# == METHODS =====================================================
# ================================================================



func _process(delta: float) -> void:
	
	# Update accelerometer ui.
	accelerometer_ui.text = "SPEED   //   " + str(linear_velocity.length()).pad_decimals(1)

	# Update steering based on a-d pressed.	
	steering = lerp(steering, Input.get_axis("left", "right") * max_wheel_turn, delta * steering_speed)
	
	# Define acceleration based on w-s pressed.
	var acceleration : float = Input.get_axis("backward", "forward") # * 100

	
	# Apply force to the wheels.
	
	
	# Get the current rpm of back-left wheel.
	var rpm : int = back_left_wheel.get_rpm()
	
	# Apply engine force to that wheel.
	back_left_wheel.engine_force = acceleration * max_torque * (1-abs(rpm) / max_rpm) # fixed backwards thing w abs
	
	# Get the current rpm of back-right wheel.	
	rpm = back_right_wheel.get_rpm()
	
	# Get the current rpm of back-left wheel.
	back_right_wheel.engine_force = acceleration * max_torque * (1-abs(rpm) / max_rpm)


	# Apply dynamic FOV.


	camera.fov = lerp(camera.fov, 70 + (linear_velocity.length() * dynamic_fov_scale), 5*delta) 

	
	# Apply braking if needed.
	
	
	if Input.is_action_pressed("brake"): 
		
		# Bug: this will also keep the car floating if in the air..
		linear_velocity = lerp(linear_velocity, Vector3.ZERO, delta * braking_speed)
		
		
	# Apply drifting force if needed.
		
	if Input.is_action_pressed("drift"):
		back_left_wheel.engine_force *= 5
		back_right_wheel.engine_force *= 5
	


func _input(event: InputEvent) -> void:
	
	# Reset car flag.
	if Input.is_action_just_pressed("reset_car"):
		should_reset = true
		
		
		
		
		
func _integrate_forces(state: PhysicsDirectBodyState3D) -> void:
	
	# Check if the reset flag is activated.
	if should_reset:
		
		# Reset flag status.
		should_reset = false

		# Lift car 2 meters into the air.
		var new_position : Vector3 = state.transform.origin + Vector3.UP * 2.0


		# Calculate up-right orientation (ChatGPT did this part).


		var up : Vector3= Vector3.UP
		
		var forward : Vector3 = state.transform.basis.z.normalized()
		
		if abs(forward.dot(up)) > 0.99:
			forward = -state.transform.basis.x.normalized()
			
		var right : Vector3 = up.cross(forward).normalized()
		
		forward = right.cross(up).normalized()
		
		var new_basis : Basis = Basis(right, up, forward)
		
		
		# Compile and apply the transformation to fully reset the car.
		
		
		var new_transform : Transform3D = Transform3D(new_basis, new_position)
		state.transform = new_transform

		
		# Reset the speed and rotation.



		linear_velocity = Vector3.ZERO
		angular_velocity = Vector3.ZERO
