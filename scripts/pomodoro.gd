extends Node

@onready var pomodoroActive = get_node("GridContainer/pomodoroActive")
@onready var pomodoroBreak = get_node("GridContainer/pomodoroBreak")
@onready var label = get_node("GridContainer/Label")
@onready var start_button = get_node("GridContainer/startButton")

var activeSessionTime = Globals.activeSessionLength
var breakTime = Globals.breakLength
var timeUp: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Active Session Length: " + str(activeSessionTime) + " secs")
	print("Break Length: " + str(breakTime) + " secs")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	label.text = str(activeSessionTime)
	if activeSessionTime == 0:
		timeUp = true

	if timeUp == true:
		pomodoroActive.stop()
		label.text = "It's time for your break!"
		await get_tree().create_timer(5).timeout
		label.text = str(breakTime)
		print("Break Time")

func _on_pomodoro_active_timeout():
	activeSessionTime -= 1
	label.text = str(activeSessionTime)

func _on_start_button_pressed():
	pomodoroActive.start()
	timeUp = false
	var nodeToRemove = get_node("GridContainer/startButton")
	nodeToRemove.hide()

func _on_pomodoro_break_timeout():
	breakTime -= 1
