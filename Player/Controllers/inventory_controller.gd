extends Node2D
class_name Inventory_Controller

@export var INVENTORY: Inv
@export var player: Player

@export var active_item: Throwable_obj
var stowed_item: Throwable_obj

func pick_up(item):
	if item.inv_item_resource:
		if active_item:
			print("The Player is already holding something")
		elif !active_item:
			active_item = item
			INVENTORY.active_item = item.inv_item_resource
			
func swap_active_item():
	if active_item:
		print_debug(active_item.inv_item_resource.can_stow)
		if active_item.inv_item_resource.can_stow:
			var prev_active = active_item
			active_item = stowed_item
			stowed_item = prev_active
			set_inv_resouces()
		else:
			pass
			## TODO somehow tell the player the item they want to stow can't be
			print_debug("Active Item Cannot be Stowed")
			## OBJ shake, noise, etc
	elif stowed_item:
		var prev_active = active_item
		active_item = stowed_item
		stowed_item = prev_active
		set_inv_resouces()
	else:
		pass

func set_inv_resouces():
	if active_item:
		INVENTORY.active_item = active_item.inv_item_resource
	else:
		INVENTORY.active_item = null
	if stowed_item:
		INVENTORY.stowed_item = stowed_item.inv_item_resource
	else:
		INVENTORY.stowed_item = null

func throw_active_item():
	if active_item:
		if active_item.has_method("throw"):
			active_item.throw(player)
			INVENTORY.active_item = null
			active_item = null
		pass
