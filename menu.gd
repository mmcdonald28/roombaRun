extends Control #Control is bc Menu is a Control Node

func _on_play_pressed():
	get_tree().change_scene_to_file("res://world.tscn")
	#this will move from the menu to the game. Changes the scene and what we see
	#The file should be whatever scene our game is in. I made a quick 2D node as an example


func _on_quit_pressed():
	get_tree().quit()
	#Exits the game


func _on_tutorial_pressed():
	#opens tutorial
	get_tree().change_scene_to_file("res://Tutorial/tutorial_1.tscn")
