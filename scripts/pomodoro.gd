extends Node

@onready var pomodoroActive = get_node("/root/Control/pomodoroActive")
@onready var pomodoroBreak = get_node("/root/Control/pomodoroBreak")
@onready var label = get_node("/root/Control/Label")
@onready var start_button = get_node("/root/Control/startButton")

var activeSessionTime = Globals.activeSessionLength
var breakTime = Globals.breakLength
var timeUp: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Active Session Length: " + str(activeSessionTime) + " secs")
	print("Break Length: " + str(breakTime) + " secs")

# Define the time left in minutes and seconds
	var minutes = 0
	var seconds = 0

# Define a variable that prints those variables in a minute:second format

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var minutes = int(activeSessionTime / 60)
	var seconds = activeSessionTime % 60
	var activeTime = "%02d:%02d" % [minutes, seconds]
	Globals.activeTime = activeTime

	label.text = str(activeTime)

	if activeSessionTime == 0:
		timeUp = true

	if timeUp == true:
		pomodoroActive.stop()
		print("Break Time")
		label.text = "It's time for your break!"
		await get_tree().create_timer(5).timeout
		label.text = str(breakTime)

func _on_pomodoro_active_timeout():
	activeSessionTime -= 1

func _on_start_button_pressed():
	pomodoroActive.start()
	timeUp = false
	var nodeToRemove = get_node("/root/Control/startButton")
	nodeToRemove.hide()

func _on_pomodoro_break_timeout():
	breakTime -= 1
