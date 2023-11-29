extends StaticBody2D

# Called when the node enters the scene tree for the first time.
func _ready():
	$CollisionShape2D.set_deferred("disabled", true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	run()
	
# If sprite is below a frame, activate collision, if below disactivate
# Only diff btwn the various trap scripts is the frames they are active
func run():
	if $AnimatedSprite2D.frame < 7:
		$CollisionShape2D.set_deferred("disabled", true)
	else:
		$CollisionShape2D.set_deferred("disabled", false)
