extends Panel

@onready var item_sprite: Sprite2D = $CenterContainer/Panel/ItemSprite

func update(item: InvItem):
	if not item:
		item_sprite.visible = false
	else: 
		item_sprite.visible = true
		item_sprite.texture = item.texture
