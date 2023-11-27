extends Resource
#resources are data containers. Nodes use the data contained in resources

class_name Inventory
#this makes it easier for us to create an instance of it that we can save later

signal updated

@export var items: Array[InventoryItem]
@export var keys = 0
#this will store the items in the inventory

func insert(item: InventoryItem):
	for i in range(items.size()):
		if !items[i]:
			if item.name == "key1" || "key2" || "key3":
				keys = keys + 1
			items[i] = item
			break
	updated.emit()
	
func clear():
	for i in range(items.size()):
		items[i] = null
	keys = 0
	updated.emit()
