extends Node2D

#Are we on part 1 of the tutorial (for the movement)?
var tutorialPart1 = true

#variables for part 1
var hitLeft = false
var hitRight = false
var hitUp = false
var hitDown = false

var textbox_open: bool = true

signal Start_Tutorial_2_text

func _ready():
	#hides and deactivates whatever we're not using
	$MazeDoor.hide()
	$Lamp1.hide()
	$Lamp2.hide()
	$"Interact Area".monitorable = false
	$Key.hide()
	$Key.monitoring = false
	

func _on_textbox_textbox_is_closed():
	textbox_open = false

func _on_textbox_textbox_is_open():
	textbox_open = true
	
func _input(event):
	if !textbox_open && tutorialPart1:
		if(event.is_action_pressed("left")):
			hitLeft = true
		
		if(event.is_action_pressed("right")):
			hitRight = true
		
		if(event.is_action_pressed("up")):
			hitUp = true
		
		if(event.is_action_pressed("down")):
			hitDown = true
		hitAllArrows()

func hitAllArrows():
	#makes sure all the arrows are pressed before progressing
	if hitLeft && hitRight && hitUp && hitDown:
		tutorialPart1 = false
		start_tutorial_2()
		

func start_tutorial_2():
	#shows and activates the door
	$MazeDoor.show()
	$Lamp1.show()
	$Lamp2.show()
	$"Interact Area".monitorable = true
	emit_signal("Start_Tutorial_2_text")
	

func _on_character_body_2d_start_tutorial_part_3():
	#shows and activates the key
	$Key.show()
	$Key.monitoring = true

