extends Control

var millis = 0
var secs = 0
var mins = 0

"""
Timer Methods
"""	
	
func _on_Timer_timeout():
	if millis > 99:
		secs += 1
		millis = 0
	if secs > 59:
		mins += 1
		secs = 0
	
	$timerLabel.text=str(mins) + " : " + str(secs) + " : " + str(millis)
	pass

func Reset_Timer():
	secs = 0
	mins = 0
	_on_Timer_timeout()

func _ready():
	Reset_Timer()
	pass
