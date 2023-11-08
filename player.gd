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

func _ready():
	#this sets up the Keys Collected Label
	#$KeyCountCanvasLayer/KeyCountPanel/KeysCollectedAmount.text = "0/NUMEBR OF KEYS IN LEVEL"
	if get_tree().current_scene.name == "world":
		$KeyCountCanvasLayer/KeyCountPanel/KeysCollectedAmount.text = "0/3"
	if get_tree().current_scene.name == "Maze": 
		$KeyCountCanvasLayer/KeyCountPanel/KeysCollectedAmount.text = "0/4"
	if get_tree().current_scene.name == "Maze 2":
		$KeyCountCanvasLayer/KeyCountPanel/KeysCollectedAmount.text = "0/3"

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
#$KeyCountCanvasLayer/KeyCountPanel/KeysCollectedAmount.text
func _on_inventory_gui_collected_keys():
	keys += 1
	print(keys)
	
	if get_tree().current_scene.name == "world":
		$KeyCountCanvasLayer/KeyCountPanel/KeysCollectedAmount.text = str(keys)+"/3"
		if keys == 3:
			collectedAllKeys = true
			print("Got all 3 keys!!!") #for testing
	
	if get_tree().current_scene.name == "Maze": 
		$KeyCountCanvasLayer/KeyCountPanel/KeysCollectedAmount.text = str(keys)+"/4"
		if keys == 4:
			collectedAllKeys = true
			print("Got all 4 keys!!!!") #for testing
		
	if get_tree().current_scene.name == "Maze 2":
		$KeyCountCanvasLayer/KeyCountPanel/KeysCollectedAmount.text = str(keys)+"/3"
		if keys == 3:
			collectedAllKeys = true
			print("Got all 3 keys!!!") #for testing
		
	#HOW TO SET IT UP (Just copy paste starting at the if)
	#To find the name of the scene, just use print(get_tree().current_scene.name)
#	#for example, I thought it was maza when it was Maze, which caused it not to work
#	if get_tree().current_scene.name == "NAME OF SCENE":
#		$KeyCountCanvasLayer/Panel/KeysCollectedAmount.text = str(keys)+"/NUMBER OF KEYS IN THE LEVEL"
#		if keys == NUMBER OF KEYS IN THE LEVEL:
#			collectedAllKeys = true


#/////////////////////////////////
#///////Interaction Methods///////
#/////////////////////////////////

func _on_interaction_area_area_entered(area):
	print("entered door area!") #for testing
	allInteractions.insert(0, area) #stores collisions in the front of the array
	getToDoor = true
	updateInteraction()
	if collectedAllKeys && getToDoor: #you need all 3 keys and to be interacting with door
		print("ALL REQUIREMENTS MET")
		keys = 0 #resetting for next level
		getToDoor = false #resetting for next level
		
		#moving to the next level
		if get_tree().current_scene.name == "world":
			get_tree().change_scene_to_file("res://maze.tscn") #maze time bby
		if get_tree().current_scene.name == "Maze":
			get_tree().change_scene_to_file("res://Game Levels/maze_2.tscn")
		if get_tree().current_scene.name == "Maze 2":
			print("To the Next World! :D")

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

