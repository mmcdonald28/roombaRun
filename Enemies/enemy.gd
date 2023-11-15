extends CharacterBody2D

#To insert an enemy: Drag scene in, instanciate 
@export var speed = 75
@export var limit = 0.5
@export var endPoint: Marker2D

@onready var animations = $AnimatedSprite2D

var startPosition
var endPosition

func _ready():
	startPosition = position
	endPosition = endPoint.global_position
	
func changeDirection():
	var temp = endPosition
	endPosition = startPosition	
	startPosition = temp
	
func updateVelocity():
	var moveDirection = (endPosition - position)
	if moveDirection.length() < limit:
		changeDirection()
	velocity = moveDirection.normalized()*speed	
	
func updateAnimation():
	var animationString = ""
	if velocity.y > 0:
		animationString = ""
	animations.play(animationString)

func _physics_process(delta):
	updateVelocity()
	move_and_slide()
	updateAnimation()
