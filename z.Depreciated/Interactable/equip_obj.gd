extends Node2D
class_name EquipObj

@export_category("Connections")
@export var interact_component : InteractComponent
@export var inv_item: InvItem

@export_category("Pick Up Variables")
@export var CAN_EQUIP: bool = false
@export var CAN_STOW: bool = false
@export var EQUIPPED: bool = false

func _ready() -> void:
	interact_component.interact.connect(_interaction_signal)
	interact_component.stop_interact.connect(_stop_interacting_signal)

func _interaction_signal(interactor: Player):
	print("obj interaction signal")
	var player_inv = interactor.INVENTORY
	
	if player_inv.active_item == null:
		if CAN_EQUIP:
			interactor.handle_equip_item(inv_item)
			self.visible = false
			var collider = self.get_node("CollisionShape2D")
			collider.disabled = true
	else: 
		pass
		#TODO: Add thud sound and an obj shake

func _stop_interacting_signal():
	pass
