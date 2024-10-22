extends Node

@onready var error = $error

var breakTime: int

# Called when the node enters the scene tree for the first time.
func _ready():
	error.text = ""

func _on_five_minutes_pressed():
	breakTime = 300
	print("Set break time to " + str(breakTime) + " seconds")

func _on_ten_minutes_pressed():
	breakTime = 600
	print("Set break time to " + str(breakTime) + " seconds")

func _on_fifteen_minutes_pressed():
	breakTime = 600
	print("Set break time to " + str(breakTime) + " seconds") 

func _on_start_button_pressed():
	if breakTime == 0:
		error.text = "Please select a Break Length"
	else:
		Globals.breakLength = breakTime
		get_tree().change_scene_to_file("res://scenes/pomodoro.tscn")
