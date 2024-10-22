extends Node

@onready var pomodoroActive = $pomodoroActive
@onready var pomodoroBreak = $pomodoroBreak
@onready var label = $Label
@onready var start_button = $startButton

var activeSessionTime = Globals.activeSessionLength
var breakTime = Globals.breakLength
var timeUp: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Active Session Length: " + str(activeSessionTime) + " secs")
	print("Break Length: " + str(breakTime) + " secs")
	timeUp = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if activeSessionTime == 0:
		timeUp = true
		pomodoroActive.stop()
	else:
		pass

func _on_pomodoro_active_timeout():
	activeSessionTime -= 1

func _on_start_button_pressed():
	pomodoroActive.start()
	var nodeToRemove = get_node('startButton')
	nodeToRemove.queue_free()

func _on_pomodoro_break_timeout():
	pass # Replace with function body.
