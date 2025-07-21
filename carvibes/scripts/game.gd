extends Node3D



# Script handles (generation, day/night cycle, and) general stuff. 



# ================================================================
# == VARIABLES ===================================================
# ================================================================



# Reference to pause menu.
@onready var pause_menu : Node = $pause_menu



# ================================================================
# == METHODS =====================================================
# ================================================================



func _ready() -> void:
	
	# Hide the cursor.
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)	



func _input(event: InputEvent) -> void:

	# In the case that the cursor shows up, click and make it disappear!
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
