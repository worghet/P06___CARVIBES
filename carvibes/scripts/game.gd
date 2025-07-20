extends Node3D


@onready var pause_menu = $pause_menu

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)	


func _input(event: InputEvent) -> void:
			# this might be redundant
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)	
				
		
