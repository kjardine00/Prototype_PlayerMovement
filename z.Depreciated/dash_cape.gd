extends Equipment
class_name BodyEquip
enum AbilityType {
	ROLL,
	DASH,
	GLIDE,
	BLINK,
	FLY,
	BARRIER,
}
var ability_type: AbilityType = AbilityType.DASH

##======================DASH CAPE================================

func enable_function_on_pickup():
	Global.player_inventory.handle_body_abilities(ability_type)
