extends CanvasLayer

@onready var inventory = $InventoryGui
#adds a reference to the inventoryGui. "inventory" goes into that Gui

func _ready():
	inventory.close()
	#think the inventory is closed initially

func _input(event):
	#go to project settings --> input map, create a new action called toggle_inventory,
	#and add the E Key as the event. E will open and close the inventory
	if event.is_action_pressed("toggle_inventory"):
		if inventory.isOpen:
			inventory.close()
		else:
			inventory.open()


