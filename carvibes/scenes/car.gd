extends VehicleBody3D

var max_rpm = 500
var max_torque = 200

func _process(delta: float) -> void:
	steering = lerp(steering, Input.get_axis("right", "left") * 0.4, 5*delta)
	
	var acceleration = Input.get_axis("backward", "forward") # * 100

	var rpm = $"back-left".get_rpm()
	
	$"back-left".engine_force = acceleration * max_torque * (1-rpm / max_rpm)
	
	rpm = $"back-right".get_rpm()
	
	$"back-right".engine_force = acceleration * max_torque * (1-rpm / max_rpm)
	
