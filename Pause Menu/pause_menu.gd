extends Control

# Called when the node enters the scene tree for the first time.
@onready var paused = false

func _ready():
	hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Pause"):
		pauseMenu()
	

func pauseMenu():
	if paused:
		hide()
		Engine.time_scale = 1
	else:
		show()
		Engine.time_scale = 0
	
	paused = !paused

func _on_resume_button_pressed():
	pauseMenu()


func _on_exit_button_pressed():
	get_tree().quit()


func _on_options_button_pressed():
	get_tree().change_scene_to_file("res://options_menu.tscn")
	#NEED TO FIX THIS


func _on_save_button_pressed():
	pauseMenu()
	# Need to figure out WHAT we're saving
	#for now, it resumes
