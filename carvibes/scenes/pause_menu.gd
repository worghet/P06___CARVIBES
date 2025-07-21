extends Control



# Script for pause menu logic.



# ================================================================
# == VARIABLES ===================================================
# ================================================================



# Local variable to keep track of state.
var paused : bool = false

# Convenient variable for the track player.
@onready var track_player : Node = get_parent().get_node("track_player")



# ================================================================
# == METHODS =====================================================
# ================================================================



func _input(event: InputEvent) -> void:
		
	# If [ESCAPE], pause/unpause the game.
	if Input.is_action_just_pressed("escape"):
		
		paused = !paused
		
		if paused:
			pause()
		else:
			resume()
			
		

func pause() -> void:
	
	# Reduce track volume.
	track_player.volume_db = -15
	
	# Show cursor.
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)	
	
	# Show the actual menu.
	show()
	
	# Pause the game.
	get_tree().paused = true

func resume() -> void:
	
	# Reset track volume.
	track_player.volume_db = 1
	
	# Hide cursor.
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# Hide the menu.
	hide()
	
	# Resume the game.
	get_tree().paused = false



func _on_ok_pressed() -> void:
	
	# Modify the local variable (its not changed in resume method).
	paused = false
	
	# Resume game.
	resume()



func _on_quit_pressed() -> void:
	
	# Unpause the actual instance so that main menu works.
	get_tree().paused = false
	
	# Switch scene to main menu.
	get_tree().change_scene_to_file("res://scenes/menu.tscn")



# ------------- CURRENTLY DOESNT WORK -------------

func _on_close_pressed() -> void:
	paused = false
	resume()


func _on_maximize_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/menu.tscn")


func _on_hide_pressed() -> void:
	paused = false
	resume()
