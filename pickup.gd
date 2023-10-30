extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# Where collision are handled 
# Body parameter is the body that enters the pickup's body (aka the player)
# Should be able to use body. to access the player
func pickup_body_entered(body):
	hide()
