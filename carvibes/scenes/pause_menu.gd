extends Control
var paused = false
@onready var track_player = get_parent().get_node("track_player")

func _input(event: InputEvent) -> void:
		
	if Input.is_action_just_pressed("escape"):
		paused = !paused
		
		if paused:
			pause()
		else:
			resume()
			
		


func pause():
	track_player.volume_db = -15
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)	
	show()
	get_tree().paused = true

func resume():
	track_player.volume_db = 1
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	hide()
	get_tree().paused = false

func _on_ok_pressed() -> void:
	paused = false
	resume()


func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menu.tscn")


func _on_close_pressed() -> void:
	paused = false
	resume()


func _on_maximize_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menu.tscn")


func _on_hide_pressed() -> void:
	paused = false
	resume()
