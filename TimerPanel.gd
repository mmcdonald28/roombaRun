extends Panel

var time: float = 0.0
var mins: int = 0
var secs: int = 0
var millis: int = 0

func _process(delta) -> void:
	time += delta
	millis = fmod(time, 1) * 100
	secs = fmod(time, 60)
	mins = fmod(time, 3600) / 60
	$Minutes.text = "%02d:" % mins
	$Seconds.text = "%02d." % secs
	$Milliseconds.text = "%03d" % millis
	
func stop() -> void:
	set_process(false)
	
func get_time_formatted() -> String:
	return "02%d:02%d.03%d" % [mins, secs, millis]
