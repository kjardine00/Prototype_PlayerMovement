extends Control
class_name ActiveStowedUI

@onready var active_item_slot: PanelContainer = $HBoxContainer/ActiveItemSlot
@onready var stowed_item_slot: PanelContainer = $HBoxContainer/StowedItemSlot

func _ready() -> void:
	update_inventory() 

func _physics_process(delta: float) -> void:
	update_inventory()

func update_inventory():
	active_item_slot.update(Global.player_inventory.active_icon)
	stowed_item_slot.update(Global.player_inventory.stowed_icon)
