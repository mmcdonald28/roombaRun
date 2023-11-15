extends Resource
#resources are data containers. Nodes use the data contained in resources

class_name Inventory
#this makes it easier for us to create an instance of it that we can save later

signal updated

@export var items: Array[InventoryItem]
#this will store the items in the inventory

func insert(item: InventoryItem):
	for i in range(items.size()):
		if !items[i]:
			items[i] = item
			break
	updated.emit()
	
func clear():
	for i in range(items.size()):
		items[i] = null
	updated.emit()
