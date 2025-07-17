extends AudioStreamPlayer


@onready var twin_peaks_mp3 = load("res://demo_stuffs/Twin Peaks Intro.mp3")
@onready var ocarina_of_time_mp3 = load("res://demo_stuffs/Ocarina of Time.mp3")
@onready var resonance_mp3 = load("res://demo_stuffs/Resonance.mp3")

@onready var track_list : Dictionary = {
	
	"twin_peaks.mp3": twin_peaks_mp3,
	"ocarina_of_time.mp3" : ocarina_of_time_mp3,
	"resonance.mp3" : resonance_mp3
	
}

@onready var track_ui = get_parent().get_parent().get_child(0).get_child(1).get_child(0)

const PREV = 0
const NEXT = 1
const START = 2


var track_index = 0

func _ready() -> void:
	
	update_track(START)


func _input(event: InputEvent) -> void:
	
	
	if Input.is_action_just_pressed("previous_track"):

		update_track(PREV)
	
	if Input.is_action_just_pressed("next_track"):
		
		update_track(NEXT)
		
	if Input.is_action_just_pressed("pause_track"):
		stream_paused = !stream_paused
		
		if stream_paused:
			track_ui.text = "<   PAUSED  :  " + track_list.keys()[track_index] + "   />"
		else:
			track_ui.text = "<   " + track_list.keys()[track_index] + "   />"
	
	
	
func update_track(ACTION):
	
	if ACTION == PREV:
		if track_index == 0:
			track_index = track_list.size()-1
		else:
			track_index -= 1
		
	
	elif ACTION == NEXT:
		if track_index < track_list.keys().size() -1:
			track_index += 1
		else:
			track_index = 0
	
	
	var track_key = track_list.keys()[track_index]
	stream = track_list.get(track_key)	
	
	#stream.resource_name
	track_ui.text = "<   " + track_key + "   />"
	play()
	




func _on_finished() -> void:
	update_track(NEXT)
	
