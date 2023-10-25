extends Control

@export var game_manager : GameManager

# Called when the node enters the scene tree for the first time.
func _ready():
		hide()
		game_manager.connect("toggle_game_paused", _on_game_manager_toggle_game_paused)


func _on_game_manager_toggle_game_paused(is_paused : bool):
		if(is_paused):
			#show()
			get_tree().change_scene_to_file("res://options_menu.tscn")
		else:
			get_tree().change_scene_to_file("res://menuMainMenu.tscn")


func _on_resume_button_pressed():
	game_manager.game_paused = false


func _on_exit_button_pressed():
	get_tree().quit()


func _on_options_button_pressed():
	get_tree().change_scene_to_file("res://options_menu.tscn")


func _on_save_button_pressed():
	game_manager.game_paused = false
	# Need to figure out WHAT we're saving
