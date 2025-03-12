extends Control
class_name EquipInventoryUI

@onready var head_equip_slot: PanelContainer = $VBoxContainer/HeadEquipSlot
@onready var body_equip_slot: PanelContainer = $VBoxContainer/BodyEquipSlot
@onready var foot_equip_slot: PanelContainer = $VBoxContainer/FootEquipSlot
@onready var charm_equip_slot: PanelContainer = $VBoxContainer/CharmEquipSlot

func _ready() -> void:
	update_inventory() 

func _physics_process(_delta: float) -> void:
	update_inventory()

func update_inventory():
	head_equip_slot.update(Global.player_inventory.head_icon)
	body_equip_slot.update(Global.player_inventory.body_icon)
	foot_equip_slot.update(Global.player_inventory.foot_icon)
	charm_equip_slot.update(Global.player_inventory.charm_icon)
