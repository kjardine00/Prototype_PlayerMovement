extends Resource
class_name Inv

@export var items: Array[InvItem]

@export_category("Equipment")
@export var active_item: InvItem
@export var stowed_item: InvItem

@export_category("Inventory")
@export var head : InvItem


func swap_active():
	if active_item.can_stow:
		var prev_active = active_item
		active_item = stowed_item
		stowed_item = prev_active
	else:
		pass
		## TODO somehow tell the player the item they want to stow can't be
		## OBJ shake, noise, etc
