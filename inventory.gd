extends Resource
#resources are data containers. Nodes use the data contained in resources

class_name Inventory
#this makes it easier for us to create an instance of it that we can save later

signal updated

@export var items: Array[InventoryItem]
@export var keys = 0
@export var canAttack = false
#this will store the items in the inventory

func insert(item: InventoryItem):
	for i in range(items.size()):
		if !items[i]:
			if item.name == "key1" || "key2" || "key3": # If picking up a key update key count
				print(item.name)
				keys = keys + 1
			if item.name == "sprayBottle": # if picking up bottle activate ability to attack
				canAttack = true
				keys = keys - 1 # Spray bottle somehow acting as a key, this is cheap fix for that
			items[i] = item
			break
	updated.emit()
	
func clear():
	for i in range(items.size()):
		items[i] = null
	keys = 0
	canAttack = false
	updated.emit()
