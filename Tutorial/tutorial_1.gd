extends Node2D

var hitLeft = false
var hitRight = false
var hitUp = false
var hitDown = false

var textbox_open: bool = true

func _input(event):
	if !textbox_open:
		#This lets us know which arrow keys were pressed.
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
	#when all movement keys are pressed, part 1 of tutorial is complete
	if hitLeft && hitRight && hitUp && hitDown:
		print("Part1 of Tutorial Complete")
		get_tree().change_scene_to_file("res://world.tscn")

# These two functions are so that we can't complete the tutorial when the textbox is showing (can't move)
func _on_textbox_textbox_is_closed():
	textbox_open = false

func _on_textbox_textbox_is_open():
	textbox_open = true
