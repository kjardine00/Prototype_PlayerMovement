extends Panel

@onready var texture_rect: TextureRect = $CenterContainer/Panel/TextureRect

func update(item: InvItem):
	if not item:
		texture_rect.visible = false
	else: 
		texture_rect.visible = true
		texture_rect.texture = item.texture
