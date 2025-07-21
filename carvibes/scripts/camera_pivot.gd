extends Node3D



# Script deals with smooth camera movement.



# ================================================================
# == VARIABLES ===================================================
# ================================================================


var direction = Vector3.FORWARD
@export var smooth_speed = 2.5

# For later, when rotation available.
var rotating_w_mouse = false


# ================================================================
# == VARIABLES ===================================================
# ================================================================


func _physics_process(delta: float) -> void:
	var current_velocity = get_parent().get_linear_velocity()
	current_velocity.y = 0
	
	
	if current_velocity.length_squared() > 1 and !rotating_w_mouse:
		direction = lerp(direction, -current_velocity.normalized(), smooth_speed*delta)
	
	# set pivot to move
	
	global_transform.basis = get_rotation_from_direction(direction)

func _unhandled_input(event: InputEvent) -> void:
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)	
	elif Input.is_action_just_pressed("escape"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)	
#
	#if Input.MOUSE_MODE_CAPTURED and Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		#rotating_w_mouse = true
		#rotate_y(0.4*delta)
	#else:
		#rotating_w_mouse = false
		
	
func get_rotation_from_direction(look_direction : Vector3) -> Basis:
	look_direction = look_direction.normalized()
	
	var x_axis = look_direction.cross(Vector3.UP)
	
	return Basis(x_axis, Vector3.UP, -look_direction)	
