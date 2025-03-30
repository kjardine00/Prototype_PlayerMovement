extends Area2D
class_name DamageComp

@export_category("Properties")
@export var damage: float
@export_enum("Blunt", "Piercing", "Slashing", "Magic") var damage_type_enum : int
var damage_type : String

func _ready() -> void:
	match damage_type_enum:
		0:
			damage_type = "Blunt"
		1:
			damage_type = "Piercing"
		2:
			damage_type = "Slashing"
		3:
			damage_type = "Magic"
