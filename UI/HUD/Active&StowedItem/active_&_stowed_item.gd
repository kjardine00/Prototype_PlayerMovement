extends Control
class_name ActiveStowedUI

@onready var active_item_slot: PanelContainer = $HBoxContainer/ActiveItemSlot
@onready var stowed_item_slot: PanelContainer = $HBoxContainer/StowedItemSlot

func _ready() -> void:
	if Global.player_inventory:
		Global.player_inventory.active_item_changed.connect(_on_active_item_changed)
		Global.player_inventory.stowed_item_changed.connect(_on_stowed_item_changed)
	update_inventory()

func _on_active_item_changed() -> void:
	active_item_slot.update(Global.player_inventory.active_icon)

func _on_stowed_item_changed() -> void:
	stowed_item_slot.update(Global.player_inventory.stowed_icon)

func update_inventory():
	active_item_slot.update(Global.player_inventory.active_icon)
	stowed_item_slot.update(Global.player_inventory.stowed_icon)
