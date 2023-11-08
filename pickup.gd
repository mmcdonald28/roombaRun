extends Area2D

#@export var texture: Texture2D #specifies how the item looks in the inventory
@export var itemRes: InventoryItem

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
# HOW TO ADD NEW PICKUPS:
# Create a new resource in the inspector window, of Inventory item resource
# Drag the image file to the texture window in the inspector
# Save the .tres file with a name in the PICKUPS FOLDER
# Next, create an inherited scene of the pickup scene file
# drag the .tres file into the itemRes part of the inspector for the scene
# drag the image into the texture of the sprite
# save the scene into pickups folder
# All done! The item will appear and show up in the iventory, the 
# itemRes variable of the pickups is what interacts with the inventory

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
	
	

