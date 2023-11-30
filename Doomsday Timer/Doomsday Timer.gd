extends Control


var time: float = 0.0 #time
var mins: int = 0 #minutes
var secs: int = 0 #seconds
var centis: int = 0 #centiseconds

func _ready():
	#How long should each world allow the player to attempt?
	if get_tree().current_scene.name == "world":
		time = 30.0 #30 secs
	if get_tree().current_scene.name == "Maze":
		time = 120.0 #2 mins
	if get_tree().current_scene.name == "Maze 2":
		time = 120.0 #2 mins
	if get_tree().current_scene.name == "Maze 3":
		time = 240.0 #4 mins
	if get_tree().current_scene.name == "Maze 4":
		time = 240.0 #4 mins


func _process(delta) -> void:
#	print("Time is: %f02." % time)
	time -= delta #updating the time with delta
	centis = fmod(time, 1) * 100 # making the centiseconds
	secs = fmod(time, 60) # making the seconds
	mins = fmod(time, 3600) / 60 # making the minutes
	
	$"CanvasLayer/Panel/Minutes Label".text = "%02d:" % mins # showing minutes
	$"CanvasLayer/Panel/Seconds Label".text = "%02d." % secs # showing seconds
	$"CanvasLayer/Panel/Centiseconds Label".text = "%2d" % centis # showing centiseconds
	
	#print("Time left (in seconds): %02d" % time)
	
	if mins == 0 && secs == 0 && centis == 0:
		print("GAME OVER")
		get_tree().change_scene_to_file("res://Game Over/game_over_scene.tscn")
	
#incase we need to stop the timer
func stop() -> void:
	set_process(false)
	
func get_time_formatted() -> String:
	return "02%d:02%d.3%d" % [mins, secs, centis] # revealing the format of the timer
