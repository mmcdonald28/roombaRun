extends Control

#This is our options menu. We will add more stuff once we figure out what to have options for
#Like Volume and Brightness or whatever

func _on_back_pressed():
	get_tree().change_scene_to_file("res://menu.tscn")
	# Goes back to the main menu
