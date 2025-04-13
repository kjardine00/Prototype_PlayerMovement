extends Equipment
class_name HeadEquip
enum AbilityType {
	NONE,
	WALL_JUMP,
}
var ability_type: AbilityType = AbilityType.WALL_JUMP

##======================WALL JUMP HEAD ITEM================================

func enable_function_on_pickup():
	Global.player_inventory.handle_head_abilities(ability_type)
