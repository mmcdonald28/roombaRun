extends Panel

@onready var backgroundSprite: Sprite2D = $background
@onready var itemSprite: Sprite2D = $CenterContainer/Panel/item

func update(item: InventoryItem):
	if !item: #if there is no item
		backgroundSprite.frame = 0 #the no item sprite
		itemSprite.visible = false
	else:
		backgroundSprite.frame = 1 #the yes item sprite
		# Rescale texture
		#var tex = item.texture
		#var smallTex = tex.duplicate()
		#smallTex.resize(tex.get_size() * 2)
		itemSprite.visible = true
		itemSprite.texture = item.texture
		#itemSprite.texture = smallTex



		
