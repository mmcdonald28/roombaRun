extends CharacterBody2D

@export var speed = 400
@export var rotation_speed = 1.5
@export var inventory: Inventory

@onready var allInteractions = []
@onready var interactLabel = $"Interaction Components/InteractLabel"
#Instead of a keys variable we will use inventory.keys to get keys directly from inventory class
@onready var collectedAllKeys = false #have you collected all 3 keys?
@onready var getToDoor = false #are you at the door?
@onready var sprite = $CharacterBody2D # sprite
@onready var animated = $sprayDown/AnimatedSpriteDown 
@onready var collision = $sprayDown/CollisionShapeDown
var lives = 3 # number of lives
var is_dead = false # boolean for dead or alive, may not be used
var invulnerable = false

var rotation_direction = 0
var can_move: bool = true # can the roomba move?
var firstHitWithDoor = true #for part 2 of the tutorial. So we only get the text once
var collectedTutorialKey = false #So the "I found it!" dialouge doesn't activate twice
var time = 0.0

#signals to activate the textbox in the tutorial
signal Reached_Door_In_Tutorial
signal Start_Tutorial_Part_3
signal Collected_Tutorial_Key
signal Final_Tutorial_Text

#beeping variables
@onready var beepTimer = Timer
@onready var allBeepInteraction = []
@onready var beepSoundObj = $BeepSound
@onready var isInsideBeep = false



func _ready():
	#this hides the timer and key count for the tutorial
	if get_tree().current_scene.name == "Tutorial_1":
		$"Camera2D/Doomsday Timer/CanvasLayer".hide()
		$KeyCountCanvasLayer/KeyCountPanel.hide()
		$Camera2D/Lives.hide()
	
	print(get_tree().current_scene.name)
	
	#this sets up the Keys Collected Label
	#$KeyCountCanvasLayer/KeyCountPanel/KeysCollectedAmount.text = "0/NUMEBR OF KEYS IN LEVEL"
	add_to_group("res://Art/Spike Trap.png") # spike trap addition
	add_to_group("res://Art/Push_Trap_Front.png") # front trap addition
	add_to_group("res://Art/Push_Trap_Right.png") # right trap addition
	add_to_group("res://Art/Fire_Trap.png") # fire trap addition
	if get_tree().current_scene.name == "world":
		$KeyCountCanvasLayer/KeyCountPanel/KeysCollectedAmount.text = "0/1"
	if get_tree().current_scene.name == "Maze": 
		$KeyCountCanvasLayer/KeyCountPanel/KeysCollectedAmount.text = "0/4"
	if get_tree().current_scene.name == "Maze 2":
		$KeyCountCanvasLayer/KeyCountPanel/KeysCollectedAmount.text = "0/3"
	if get_tree().current_scene.name == "Maze_3":
		$KeyCountCanvasLayer/KeyCountPanel/KeysCollectedAmount.text = "0/3"
	if get_tree().current_scene.name == "Maze_4":
		$KeyCountCanvasLayer/KeyCountPanel/KeysCollectedAmount.text = "0/4"

func get_input():
	if can_move:
		var input_direction = Input.get_vector("left", "right", "up", "down")
		velocity = input_direction * speed
		if Input.is_action_just_pressed("attack"):
			attack()
		# Attack input stuff here

func attack():
	#var input_direction = Input.get_vector("left", "right", "up", "down")
	#if input_direction == "down":
	#	var animated = $sprayDown/AnimatedSpriteDown 
	#	var collision = $sprayDown/CollisionShapeDown
	#elif input_direction == "right":
	#	var animated =  $sprayRight/AnimatedSpriteRight
	#	var collision = $sprayRight/CollisionShapeRight
	#elif input_direction == "up":
	#	var animated = $sprayDown/AnimatedSpriteDown 
	#	var collision = $sprayDown/CollisionShapeDown
	#elif input_direction == "left":
	#	var animated = $sprayDown/AnimatedSpriteDown 
	#	var collision = $sprayDown/CollisionShapeDown
		
	if inventory.canAttack == true:
		animated.visible = true
		collision.set_deferred("enabled", true)
		animated.play("sprayDown")
		await animated.animation_finished
		animated.visible = false
		collision.set_deferred("disabled", true)
		
# The physics function, occurs ever time unit, houses all the things we have to do and check etc
func _physics_process(delta):
	if can_move:
		get_input()
		move_and_slide()
		if invulnerable == false:
			handleEnemyCollision()
		checkDeath()

#this function is for the animation of the sprite
func _input(event):
	if can_move:
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
	print("Key collected")
	
	if get_tree().current_scene.name == "Tutorial_1":
		collectedAllKeys = true
		print("Got the only Key!")
		if !collectedTutorialKey:
			emit_signal("Collected_Tutorial_Key") #activate the textbox
			collectedTutorialKey = true
		
	if get_tree().current_scene.name == "world":
		$KeyCountCanvasLayer/KeyCountPanel/KeysCollectedAmount.text = str(inventory.keys)+"/1"
		if inventory.keys == 1:
			collectedAllKeys = true
			print("Got the key!") #for testing
	
	if get_tree().current_scene.name == "Maze": 
		$KeyCountCanvasLayer/KeyCountPanel/KeysCollectedAmount.text = str(inventory.keys)+"/4"
		if inventory.keys == 4:
			collectedAllKeys = true
			print("Got all 4 keys!!!!") #for testing
		
	if get_tree().current_scene.name == "Maze 2":
		$KeyCountCanvasLayer/KeyCountPanel/KeysCollectedAmount.text = str(inventory.keys)+"/3"
		if inventory.keys == 3:
			collectedAllKeys = true
			print("Got all 3 keys!!!") #for testing
			
	if get_tree().current_scene.name == "Maze_3":
		$KeyCountCanvasLayer/KeyCountPanel/KeysCollectedAmount.text = str(inventory.keys)+"/3"
		if inventory.keys == 3:
			collectedAllKeys = true
			print("Got all 3 keys!!!") #for testing
		
	if get_tree().current_scene.name == "Maze_4":
		$KeyCountCanvasLayer/KeyCountPanel/KeysCollectedAmount.text = str(inventory.keys)+"/4"
		if inventory.keys == 4:
			collectedAllKeys = true
			print("Got all 4 keys!!!") #for testing


#/////////////////////////////////
#///////Interaction Methods///////
#/////////////////////////////////

func _on_interaction_area_area_entered(area):
	print("entered door area!") #for testing
	allInteractions.insert(0, area) #stores collisions in the front of the array
	getToDoor = true
	updateInteraction()
	
	if get_tree().current_scene.name == "Tutorial_1" && firstHitWithDoor:
		emit_signal("Reached_Door_In_Tutorial") ##activate the textbox
		firstHitWithDoor = false #so we only get the "Locked door" text once
		emit_signal("Start_Tutorial_Part_3") #in tutorial_1 scene. Shows key
	
	if collectedAllKeys && getToDoor: #you need all 3 keys and to be interacting with door
		print("ALL REQUIREMENTS MET")
		inventory.clear() # clears inventory 
		getToDoor = false #resetting for next level
		
		if get_tree().current_scene.name == "Tutorial_1":
			emit_signal("Final_Tutorial_Text") #activates the textbox
		
		Global.totalTime += time
		print(time)
		print (Global.totalTime)
		
		#moving to the next level
		if get_tree().current_scene.name == "world":
			get_tree().change_scene_to_file("res://Game Levels/maze_2.tscn") #maze time bby
		if get_tree().current_scene.name == "Maze":
			get_tree().change_scene_to_file("res://Game Levels/maze_3.tscn")
		if get_tree().current_scene.name == "Maze 2":
			get_tree().change_scene_to_file("res://maze.tscn")
		if get_tree().current_scene.name == "Maze_3":
			get_tree().change_scene_to_file("res://Game Levels/maze_4.tscn")
		if get_tree().current_scene.name == "Maze_4":
			get_tree().change_scene_to_file("res://Game Win/game_win_scene.tscn")


func _on_interaction_area_area_exited(area):
	#removes the collision area we just exited
	allInteractions.erase(area)
	getToDoor = false 
	interactLabel.text = ""
	updateInteraction()

func updateInteraction():
	#this updates the text of the label for the interaction
	if lives == 0:
		interactLabel.text = "GAME OVER!" #if lives are lost
	else: # if there is life still around
		if allInteractions:
			if collectedAllKeys == false && !get_tree().current_scene.name == "Tutorial_1": # without all the keys
				interactLabel.text = "The door seems to be locked..."
			else:
				interactLabel.text = "" # opening the door

# Collision methods

# TO INSERT TRAPS / ENEMIES:
# Add the slime (adding slime has extra steps look at enemy.gd) or the trap
# rename the trap/slime to something like "greenSlime" or "fireTrap2"
# the name MUST have the word "Trap" or "Slime" in it in order for collision to 
# be properly detected
func handleEnemyCollision():
	# All of this is to get the specific collider, the thing player collides into
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if "Slime" in collider.name or "Trap" in collider.name:
			lives = lives - 1
			$"Camera2D/Lives/Panel/Lives Number Label".text = str(lives) 
			invulnerable = true # So the roomba can only lose 1 life per second
			await get_tree().create_timer(1.0).timeout
			invulnerable = false
			print("Lives Left: ", lives) # losing one lif

# Function to check death and reset what must be reset
func checkDeath():
	if lives <= 0: 
		print("You died")
		get_tree().change_scene_to_file("res://Game Over/game_over_scene.tscn")
		is_dead = true # Does nothing??
		lives = 3
		inventory.clear()


#/////////////////////////////////
#/////////Textbox Methods/////////
#/////////////////////////////////

#These are so that the player cannot move while the textbox is open
func _on_textbox_textbox_is_closed():
	can_move = true

func _on_textbox_textbox_is_open():
	can_move = false

func _on_hitbox_body_entered(sprite):
	if lives > 0 and sprite.is_in_group("slime") or sprite.is_in_group("spikes") or sprite.is_in_group("fire") or sprite.is_in_group("traps"): # if runninf into any enemies
		lives -= 1
		get_tree().reload_current_scene()
		checkDeath() # reinforcing check death
		
		
		
#/////////////////////////////////
#///// Beeping Stuff //////////
#//////////////////////////////

func _process(delta):
	# Check if any general beeping sound is not playing, then play it
	
	if not beepSoundObj.is_playing() and isInsideBeep:
		beepSoundObj.play()
	
	for beepSoundObj in allBeepInteraction:
		if not beepSoundObj.is_playing():
			beepSoundObj.play()

	time += delta

func _on_beep_area_area_entered(area):
	#check if entered interactable item is a key
	print("entered")
	if area.isKey:
		isInsideBeep = true
		beepSoundObj.play()
		print("entered key area")
	else:
		#add general interaction area sound to list
		allInteractions.insert(0, area)
		getToDoor = true
		updateInteraction()


func _on_beep_area_area_exited(area):
		#remove from list again
		allBeepInteraction.erase(area)
		isInsideBeep = false
		getToDoor = false
		interactLabel.text = ""
		updateInteraction()



#/////////////////////////////////
#/////// Old Time Stuff //////////
#/////////////////////////////////

##Save data Things
#
#var timeDicto = {}
#var lvlNum = 0
#var lvlTime = 0.0
#var filePath = "user://saveTime.res"
#
##/////////////////////////
##//// Saving Time ///////
##////////////////////////
#func saveTime():
#	var lvlName = "Level"
#
#	if get_tree().current_scene.name == "world" :
#		#michael's earlier stuff
#		lvlNum = 1
#		lvlTime = str($Camera2D/TimerCanvasLayer/TimerPanel/Minutes) + ":" + str($Camera2D/TimerCanvasLayer/TimerPanel/Seconds) + ":" + str($Camera2D/TimerCanvasLayer/TimerPanel/Centiseconds)
#		timeDicto.insert(0, lvlName + str(lvlNum), lvlTime)
#
#		var result = ResourceSaver.save(filePath, timeDicto)
#
#		if result == OK:
#			print("Data Saved successfully")
#		else:
#			print("Error Saving data")
#
#		#the newer stuff (remeber to call this whole function when we change level)
#		lvlNum = 2
#		lvlTime = str(lvlTime)
#		print(lvlTime)
#		#lvlTime = str($Camera2D/TimerCanvasLayer/TimerPanel/Minutes) + ":" + str($Camera2D/TimerCanvasLayer/TimerPanel/Seconds) + ":" + str($Camera2D/TimerCanvasLayer/TimerPanel/Centiseconds)
#
#		timeDicto[str(lvlName + str(lvlNum))] = (lvlTime)
#
#		#var result = ResourceSaver.save(filePath, timeDicto)
#
#		#var result = FileAccess.open("res://Data/")
#
##		if result == OK:
##			print("Data Saved successfully")
##		else:
##			print("Error Saving data")
#
#
#	# Maze, Maze 2, Maze 3, Maze 4
#	if get_tree().current_scene.name == "Maze 2" :
#		#michael's earlier stuff
#		lvlNum = 2
#		lvlTime = str($Camera2D/TimerCanvasLayer/TimerPanel/Minutes) + ":" + str($Camera2D/TimerCanvasLayer/TimerPanel/Seconds) + ":" + str($Camera2D/TimerCanvasLayer/TimerPanel/Centiseconds)
#		timeDicto.insert(0, lvlName + str(lvlNum), lvlTime)
#
#		var result = ResourceSaver.save(filePath, timeDicto)
#
#		if result == OK:
#			print("Data Saved successfully")
#		else:
#			print("Error Saving data")
#
#		#the newer stuff (remeber to call this whole function when we change level)
#		lvlNum = 2
#		lvlTime = str(lvlTime)
#		print(lvlTime)
#		#lvlTime = str($Camera2D/TimerCanvasLayer/TimerPanel/Minutes) + ":" + str($Camera2D/TimerCanvasLayer/TimerPanel/Seconds) + ":" + str($Camera2D/TimerCanvasLayer/TimerPanel/Centiseconds)
#
#		timeDicto[str(lvlName + str(lvlNum))] = (lvlTime)
#
#		#var result = ResourceSaver.save(filePath, timeDicto)
#
#		#var result = FileAccess.open("res://Data/")
#
##		if result == OK:
##			print("Data Saved successfully")
##		else:
##			print("Error Saving data")
#
#
#	if get_tree().current_scene.name == "Maze" :
#		lvlNum = 3
#		lvlTime = str($Camera2D/TimerCanvasLayer/TimerPanel/Minutes) + ":" + str($Camera2D/TimerCanvasLayer/TimerPanel/Seconds) + ":" + str($Camera2D/TimerCanvasLayer/TimerPanel/Centiseconds)
#		timeDicto.insert(0, lvlName + str(lvlNum), lvlTime)
#		var result = ResourceSaver.save(filePath, timeDicto)
#
#		if result == OK:
#			print("Data Saved successfully")
#		else:
#			print("Error dSaving Data")
#
#	if get_tree().current_scene.name == "Maze_3" :
#		lvlNum = 4
#		lvlTime = str($Camera2D/TimerCanvasLayer/TimerPanel/Minutes) + ":" + str($Camera2D/TimerCanvasLayer/TimerPanel/Seconds) + ":" + str($Camera2D/TimerCanvasLayer/TimerPanel/Centiseconds)
#		timeDicto.insert(0, lvlName + str(lvlNum), lvlTime)
#		var result = ResourceSaver.save(filePath, timeDicto)
#
#		if result == OK:
#			print("Data Saved successfully")
#		else: 
#			print("Error saving Data")
#
#
#	if get_tree().current_scene.name == "Maze_4" :
#		lvlNum = 5
#		lvlTime = str($Camera2D/TimerCanvasLayer/TimerPanel/Minutes) + ":" + str($Camera2D/TimerCanvasLayer/TimerPanel/Seconds) + ":" + str($Camera2D/TimerCanvasLayer/TimerPanel/Centiseconds)
#		timeDicto.insert(0, lvlName + str(lvlNum), lvlTime)
#		var result = ResourceSaver.save(filePath, timeDicto)
#
#		if result == OK:
#			print("Data Saved successfully")
#		else:
#			print("Error saving data")
#
#
#func readTime():
#	var resource_loader = ResourceLoader.new()
#	var resource = resource_loader.load(filePath)
#
#	if resource != null:
#		var timeDicto = resource.get_data()
#
#		for key in timeDicto.keys():
#			var levelName = key
#			var levelTime = timeDicto[key]
#
#			# Do something with levelName and levelTime
#			print("Level:", levelName, "Time:", levelTime)
#
#		print("Data Read successfully")
#	else:
#		print("Error Reading data")
