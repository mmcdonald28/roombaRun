extends CharacterBody2D

@export var speed = 400
@export var rotation_speed = 1.5
@export var inventory: Inventory

@onready var allInteractions = []
@onready var interactLabel = $"Interaction Components/InteractLabel"
@onready var keys : int = 0 #how many keys (or items cause i cant single items out) the user has
@onready var collectedAllKeys = false #have you collected all 3 keys?
@onready var getToDoor = false #are you at the door?

var rotation_direction = 0
	
func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

func _physics_process(delta):
	get_input()
	move_and_slide()

#this function is for the animation of the sprite
func _input(event):
	if(event.is_action_pressed("left")):
		$Icon.texture = load("res://Art/icon.png")
		
	if(event.is_action_pressed("right")):
		$Icon.texture = load("res://Art/icon - RIght.png")
		
	if(event.is_action_pressed("up")):
		$Icon.texture = load("res://Art/icon - Up.png")
		
	if(event.is_action_pressed("down")):
		$Icon.texture = load("res://Art/icon - Down.png")
	
#this function counts the items collected. There are 3 total
func _on_inventory_gui_collected_keys():
	keys += 1
	if keys == 3:
		collectedAllKeys = true
		print("Got all keys!!!") #for testing


#/////////////////////////////////
#///////Interaction Methods///////
#/////////////////////////////////

func _on_interaction_area_area_entered(area):
	allInteractions.insert(0, area) #stores collisions in the front of the array
	getToDoor = true
	updateInteraction()
	if collectedAllKeys && getToDoor: #you need all 3 keys and to be interacting with door
		keys = 0 #resetting for next level
		getToDoor = false #resetting for next level
		
		#moving to the next level
		if get_tree().current_scene.name == "world":
			get_tree().change_scene_to_file("res://maze.tscn") #maze time bby
#		if get_tree().current_scene.name == "maze":
#			get_tree().change_scene_to_file(WHATEVER IS NEXT)

func _on_interaction_area_area_exited(area):
	#removes the collision area we just exited
	allInteractions.erase(area)
	getToDoor = false 
	updateInteraction()

func updateInteraction():
	#this updates the text of the label for the interaction
	if allInteractions:
		if collectedAllKeys == false:
			interactLabel.text = "The door seems to be locked..."
	else:
		interactLabel.text = ""

