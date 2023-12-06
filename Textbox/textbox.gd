extends CanvasLayer

const CHAR_READ_RATE = 0.05 #How fast do letters go?

var finishedTutorial = false

@onready var textboxContainer = $TextboxContainer
@onready var textContainer = $TextContainer
@onready var start_symbol = $TextContainer/HBoxContainer/Start #The symbol on the top left
@onready var text = $TextContainer/HBoxContainer/Text
@onready var end_symbol = $TextContainer/HBoxContainer/End #The symbol on the bottom right

enum State {
	READY,#Ready to read in queued text. Checks if there's text in queue
	READING, #Reading the text (it's moving)
	FINISHED #All text is present
	}

var current_state = State.READY
var text_queue = [] #the list of text to show

signal textbox_is_open
signal textbox_is_closed

# Called when the node enters the scene tree for the first time.
func _ready():
	print("Starting state: State.READY")
	hide_textbox()
	if get_tree().current_scene.name == "Tutorial_1":
		start_tutorial()
		

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match current_state:
		State.READY:
			if !text_queue.is_empty(): #there is queued text
				display_text() #show the text
				emit_signal("textbox_is_open") #tell others that the box is open
		State.READING:
			if Input.is_action_just_pressed("ui_accept"): #enter key is pressed
				print("READFAST EH?")
				text.visible_ratio = 1.0 #shows all text immediately
				end_symbol.text = "v" #shows end symbol immediately
				change_state(State.FINISHED)
		State.FINISHED:
			if Input.is_action_just_pressed("ui_accept"):
				change_state(State.READY) 
				if text_queue.is_empty(): #no more text
					hide() #hide box
					emit_signal("textbox_is_closed") #tell others that the box is closed
					if finishedTutorial:
						print("world time")
						get_tree().change_scene_to_file("res://world.tscn")

func queue_text(next_text):
	text_queue.push_back(next_text)
	#puts all the text in the array 

func hide_textbox():
	#deletes all text and hides box
	start_symbol.text = ""
	text.text = ""
	end_symbol.text = ""
	hide()

func show_textbox():
	#showes the box with the start symbol
	start_symbol.text = "^ "
	show()
	
func display_text():
	var next_text = text_queue.pop_front() #prepares the next text to be shown
	text.visible_characters = 0 #no text visible to start
	text.text = next_text #set next text
	change_state(State.READING)
	show_textbox()
	
	end_symbol.text = "" #deletes end symbol
	while text.visible_characters <= len(next_text): #while not all characters are visible...
		if text.visible_characters == -1: #break from loop if all text is visible
			break
		text.visible_characters += 1 #read one character at a time
		await get_tree().create_timer(0.02).timeout #adjust display speed (0.02)
	if text.visible_characters > len(next_text[2]) || text.visible_characters == -1: #if all text has been read
		end_symbol.text = " v"
		current_state = State.FINISHED

#this function changes the read state and outputs which state we're on
func change_state(next_state):
	current_state = next_state
	match current_state:
		State.READY:
			print("Changing state to: State.READY")
		State.READING:
			print("Changing state to: State.READING")
		State.FINISHED:
			print("Changing state to: State.FINISHED")

#/////////////////////////////////
#//////////Tutorial Text//////////
#/////////////////////////////////

func start_tutorial():
	queue_text("...             \n[Hit the enter or space key to continue.]")
	queue_text("...")
	queue_text("......................................")
	queue_text("Unngh..?")
	queue_text("Where... Where am I?")
	queue_text("It's so dark... I can't see a thing.")
	queue_text("...")
	queue_text("I don't remember how I got here. Am I damaged? Can I still move?")
	queue_text("[Hit enter/space, then hit each of the arrow keys to move.]")

func _on_tutorial_1_start_tutorial_2_text():
	queue_text("So I can move around fine. That's good, let's focus on the positives.")
	queue_text("Woah! The lights on that door just came on!")
	queue_text("Was... Was that there the whole time? Did I just not see it in my confusion?")
	queue_text("The real question is why there's a door on the floor...")
	queue_text("I should see if it's open...")


func _on_character_body_2d_reached_door_in_tutorial():
	queue_text("Dang. It's locked.")
	queue_text("Maybe There's a key around?")
	

func _on_character_body_2d_collected_tutorial_key():
	queue_text("I found it!")
	queue_text("Let's see if it opens the door.")
	queue_text("[Press the E key to see the key in your inventory!]")

func _on_character_body_2d_final_tutorial_text():
	queue_text("*Click* \nIt fits! Let's get out of here!")
	queue_text("Wait, since I don't know where I am or who brought me here,")
	queue_text("I should be careful. Who knows what's behind this door?")
	queue_text("Well... hope only comes from progress, and progress is opening the door.")
	queue_text("[You have completed the Tutorial! Good luck out there...]")
	finishedTutorial = true
