extends Control

var winningTime = Global.totalTime
var mins: int = 0 #minutes
var secs: int = 0 #seconds
var centis: int = 0 #centiseconds


func _ready():

	centis = fmod(winningTime, 1) * 100 # making the centiseconds
	secs = fmod(winningTime, 60) # making the seconds
	mins = fmod(winningTime, 3600) / 60 # making the minutes
	print(mins)
	print(secs)
	print(centis)
	
	$"Your Time Numbers Label2".text = "%02d:%02d.%02d" % [mins, secs, centis]
	
	Global.totalTime = 0.0 #resetting the time for future games


func _on_quit_pressed():
	get_tree().quit()


func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://menuMainMenu.tscn")


func _on_retry_pressed():
	get_tree().change_scene_to_file("res://world.tscn")




#This is also where we will set the times
