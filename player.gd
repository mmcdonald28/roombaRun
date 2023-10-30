extends CharacterBody2D

@export var speed = 400
@export var rotation_speed = 1.5

var rotation_direction = 0
	
func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed

func _physics_process(delta):
	get_input()
	move_and_slide()

func _input(event):
	if(event.is_action_pressed("left")):
		$Icon.texture = load("res://Art/icon.png")
		
	if(event.is_action_pressed("right")):
		$Icon.texture = load("res://Art/icon - RIght.png")
		
	if(event.is_action_pressed("up")):
		$Icon.texture = load("res://Art/icon - Up.png")
		
	if(event.is_action_pressed("down")):
		$Icon.texture = load("res://Art/icon - Down.png")
	
#func _on_Player_body_entered(body):
	#hide()
	#if body.is_in_group("Collectibles"):
		#print("Collision!")
		#body.queue_free()  # Remove the collectible
			# Add to inventory:
