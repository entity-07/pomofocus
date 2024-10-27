extends Node

@onready var next_button = get_node("/root/Control/nextButton")
@onready var fifteen_minutes = get_node("/root/Control/fifteenMinutes")
@onready var twenty_five_minutes = get_node("/root/Control/twentyFiveMinutes")
@onready var fifity_minutes = get_node("/root/Control/fiftyMinutes")
@onready var error = get_node("/root/Control/error")

var startTime = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	error.text = ""
   
func _on_fifteen_minutes_pressed():
	startTime = 900
	print("Time set to " + str(startTime) + " secs")
	error.text = "Active Session length set to 15 Minutes"
 
func _on_twenty_five_minutes_pressed():
	startTime = 1500
	print("Time set to " + str(startTime) + " secs")
	error.text = "Active Session length set to 25 Minutes"
	
func _on_fifity_minutes_pressed():
	startTime = 3000
	print("Time set to " + str(startTime) + " secs")
	error.text = "Active Session length set to 50 Minutes"
	 
func _on_next_button_pressed():
	if startTime == 0:
		error.text = "Please select an Active Session length"
	else: 
		Globals.activeSessionLength = startTime
		get_tree().change_scene_to_file("res://scenes/BreakLengthSelector.tscn")
