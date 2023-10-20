extends Resource
#resources are data containers. Nodes use the data contained in resources

class_name Inventory
#this makes it easier for us to create an instance of it that we can save later

@export var items: Array[InventoryItem]
#this will store the items in the inventory
