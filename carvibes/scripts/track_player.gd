extends AudioStreamPlayer



# Script for the track (music) manager/player.



# ================================================================
# == VARIABLES ===================================================
# ================================================================



# Reference the gui that shows track info.
@onready var track_ui : Node = get_parent().get_child(0).get_child(1).get_child(0)

# Load the song mp3 files. This will later have OST tracks.
@onready var cassette_mp3 : Resource = load("res://demo_stuffs/tape-cassette-insert-172758.mp3")
@onready var twin_peaks_mp3 : Resource = load("res://demo_stuffs/Twin Peaks Intro.mp3")
@onready var ocarina_of_time_mp3 : Resource = load("res://demo_stuffs/Ocarina of Time.mp3")
@onready var resonance_mp3 : Resource = load("res://demo_stuffs/Resonance.mp3")
@onready var kagefumi_mp3 : Resource = load("res://demo_stuffs/Kagefumi.mp3")

# Might add "listen to your own music" logic later. 

# Assemble a dictionary of the cover names, and the resource reference.
@onready var track_list : Dictionary = {
	
	"twin_peaks.mp3": twin_peaks_mp3,
	"ocarina_of_time.mp3" : ocarina_of_time_mp3,
	"resonance.mp3" : resonance_mp3,
	"kagefumi.mp3" : kagefumi_mp3
	
}

# Constants for the update_track() method.
const PREV : int = 0
const NEXT : int = 1
const START : int = 2

# Keep track of which track to play.
var track_index : int = 0

# Fixes a bug where "finished()" signal is called twice.
var cassette_playing : bool = true



# ================================================================
# == METHODS =====================================================
# ================================================================



func _ready() -> void:
	
	# Play the first track.
	update_track(START)



func _input(event: InputEvent) -> void:
	
	# If [UP_ARROW] pressed, go back one track.
	if Input.is_action_just_pressed("previous_track"):
		update_track(PREV)
	
	
	
	# If [DOWN_ARROW] pressed, go to the next track.
	if Input.is_action_just_pressed("next_track"):
		update_track(NEXT)
		
		
	# If [P] pressed, then pause this player.
	if Input.is_action_just_pressed("pause_track"):
		
		# Pause the stream.
		stream_paused = !stream_paused
		
		# Update the ui.
		if stream_paused:
			track_ui.text = "<   PAUSED  :  " + track_list.keys()[track_index] + "   />"
		else:
			track_ui.text = "<   " + track_list.keys()[track_index] + "   />"
	
	
	
func update_track(ACTION : int) -> void:
	
	# Play the cassette effect.
	stream = cassette_mp3
	track_ui.text = "<   inserting..   />"
	cassette_playing = true
	play()
	await self.finished
	cassette_playing = false
	
	
	# Compare action parameter, update track index accordingly.
	
	
	# Go back one track.
	if ACTION == PREV:
		
		# Prevent index error.
		if track_index == 0:
			track_index = track_list.size()-1
		else:
			track_index -= 1
	
		
	# Go to next track.
	elif ACTION == NEXT:
		
		# Prevent index error.
		if track_index < track_list.keys().size() -1:
			track_index += 1
		else:
			track_index = 0
	
	
	# Using new track index, update everything.
	
	
	# Get the key of the track from the tracklist.
	var track_key : String = track_list.keys()[track_index]
	
	# Set the resource to the stream.
	stream = track_list.get(track_key)	
	
	# Update ui.
	track_ui.text = "<   " + track_key + "   />"
	
	# Play the track.
	play()
	


func _on_finished() -> void:
	if !cassette_playing:
		update_track(NEXT)
	
