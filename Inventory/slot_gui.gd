extends Panel

@onready var backgroundSprite: Sprite2D = $background
@onready var itemSprite: Sprite2D = $CenterContainer/Panel/item

func update(item: InventoryItem):
	if !item: #if there is no item
		backgroundSprite.frame = 0 #the no item sprite
		itemSprite.visible = false
	else:
		backgroundSprite.frame = 1 #the yes item sprite
		itemSprite.visible = true
		itemSprite.teture = item.texture
		
