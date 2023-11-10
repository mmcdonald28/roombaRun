extends Panel

var time: float = 0.0 #time
var mins: int = 0 #minutes
var secs: int = 0 #seconds
var centis: int = 0 #centiseconds

func _process(delta) -> void:
	time += delta #updating the time with delta
	centis = fmod(time, 1) * 100 # making the centiseconds
	secs = fmod(time, 60) # making the seconds
	mins = fmod(time, 3600) / 60 # making the minutes
	$Minutes.text = "%02d:" % mins # showing minutes
	$Seconds.text = "%02d." % secs # showing seconds
	$Centiseconds.text = "%3d" % centis # showing centiseconds
	
func stop() -> void:
	set_process(false)
	
func get_time_formatted() -> String:
	return "02%d:02%d.3%d" % [mins, secs, centis] # revealing the format of the timer
