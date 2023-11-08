extends Control

#extends Resource
#resources are data containers. Nodes use the data contained in resources

signal opened
signal closed
#we will use these signals above to pause the game while the inventory is open
signal collectedKeys

var isOpen: bool = false
var firstUpdate: bool = true

#for when we have a player
@onready var inventory: Inventory = preload("res://playerInventory.tres")
@onready var slots: Array = $NinePatchRect/GridContainer.get_children()

func _ready():
	inventory.updated.connect(update)
	update()


#for when we have a player
func update():
	#it is split up so the first update (ready function) does not count a key
	if firstUpdate:
		for i in range(min(inventory.items.size(), slots.size())):
			slots[i].update(inventory.items[i])
			firstUpdate = false
	else:
		for i in range(min(inventory.items.size(), slots.size())):
			slots[i].update(inventory.items[i])
		keyCount()

#signals the Player Node. Counts items collected
func keyCount():
	emit_signal("collectedKeys")

func open():
	visible = true
	isOpen = true
	opened.emit()

func close():
	visible = false
	isOpen = false
	closed.emit()

#Remember to set the CanvasLayer's Process Mode to Always, or the Gui Layer would also be paused and we wouldn't be able to close inventory
func _on_inventory_gui_closed():
	get_tree().paused = false

func _on_inventory_gui_opened():
	get_tree().paused = true
