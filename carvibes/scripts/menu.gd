extends Node3D



# Script is for the main menu logic.



# ================================================================
# == VARIABLES ===================================================
# ================================================================



# Load filepaths for the cursor variants.
var normal : Resource = load("res://demo_stuffs/Normal-Select (1).png")
var pointer : Resource = load("res://demo_stuffs/Select (1).png")

# Load the vehicle model.
@onready var vehicle_model : Node = $"FiatUno1998"



# ================================================================
# == METHODS =====================================================
# ================================================================



func _ready() -> void:
	
	# Setup the cursor.
	Input.set_custom_mouse_cursor(normal)
	Input.set_custom_mouse_cursor(pointer, Input.CURSOR_POINTING_HAND)



func _process(delta: float) -> void:
	
	# Just have the vehicle model rotate slowly.
	vehicle_model.rotate_y(deg_to_rad(20 * delta))



func _on_exit_button_pressed() -> void:
	
	# Close the game.
	get_tree().quit()



func _on_start_button_pressed() -> void:

	# Open the game itself.
	get_tree().change_scene_to_file("res://scenes/game.tscn")
