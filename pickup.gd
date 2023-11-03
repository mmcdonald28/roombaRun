extends Area2D

#@export var texture: Texture2D #specifies how the item looks in the inventory
@export var itemRes: InventoryItem

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

# func to add to inventory, will be called upon collision
func collect (inventory: Inventory):
	inventory.insert(itemRes)
	queue_free()
	hide()

# Where collision are handled 
# Body parameter is the body that enters the pickup's body (aka the player)
# Uses the body to access the players inv
func pickup_body_entered(body):
	collect(body.inventory)
	
	

