extends Area2D
class_name HealthComp

@export_category("Properties")
@export var MAX_HEALTH: int
@export var current_health: int

signal damage_taken(amount, type)
signal health_below_zero

func _ready() -> void:
	if current_health && MAX_HEALTH:
		current_health = MAX_HEALTH
	else:
		printerr("Set current health and max health values for this entity")

func _on_area_entered(area: Area2D) -> void:
	print_debug(area, " Damage touched health")
	current_health -= area.damage
	damage_taken.emit(area.damage, area.damage_type)
