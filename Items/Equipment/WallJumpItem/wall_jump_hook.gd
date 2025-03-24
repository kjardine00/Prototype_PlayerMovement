extends Equipment
class_name HeadEquip

##======================WALL JUMP HEAD ITEM================================

func enable_function_on_pickup():
	Global.player_inventory.handle_head_abilities("Wall Jump")
