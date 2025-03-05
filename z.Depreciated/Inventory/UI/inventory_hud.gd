extends Control

@onready var inv: Inv = preload("res://Player/Components/player_inventory.tres")
@onready var grid_container: GridContainer = $GridContainer
@onready var inventory_ui_slot_1: Panel = $GridContainer/Inventory_UI_slot1
@onready var inventory_ui_slot_2: Panel = $GridContainer/Inventory_UI_slot2

var slots : Array

func _ready():
	slots = grid_container.get_children()
	update_slots()
	
func update_slots():
	inventory_ui_slot_1.update(inv.active_item)
	inventory_ui_slot_2.update(inv.stowed_item)

func _physics_process(_delta: float) -> void:
	update_slots()
