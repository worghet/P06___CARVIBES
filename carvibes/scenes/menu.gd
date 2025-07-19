extends Node3D

var normal = load("res://demo_stuffs/Normal-Select (1).png")
var pointer = load("res://demo_stuffs/Select (1).png")

@onready var vehicle_model = $"FiatUno1998"

func _ready() -> void:
	Input.set_custom_mouse_cursor(normal)
	Input.set_custom_mouse_cursor(pointer, Input.CURSOR_POINTING_HAND)


func _process(delta: float) -> void:
	vehicle_model.rotate_y(deg_to_rad(20 * delta))

func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")
