extends PanelContainer

@onready var icon: TextureRect = $Icon

func update(item_icon):
	if not item_icon:
		icon.visible = false
	else: 
		icon.visible = true
		icon.texture = item_icon
