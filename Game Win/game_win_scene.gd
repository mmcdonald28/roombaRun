extends Control


func _on_quit_pressed():
	get_tree().quit()


func _on_main_menu_pressed():
	get_tree().change_scene_to_file("res://menuMainMenu.tscn")


func _on_retry_pressed():
	get_tree().change_scene_to_file("res://world.tscn")




#This is also where we will set the times
