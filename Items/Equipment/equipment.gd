extends CharacterBody2D
class_name Equipment

@export_category("Connections")
@export var interact_component : InteractComponent
@export var hitbox : CollisionShape2D
@export var sprite: Sprite2D

@export_category("Properties")
enum Equip_Slot {
	HEAD, 
	BODY, 
	FOOT, 
	CHARM
}
@export var equip_slot : Equip_Slot

@export_group("UI Elements")
## Must be a square icon with dimensions 0x0 px
@export var icon : Texture

func _ready() -> void:
	interact_component.interact.connect(_interaction_signal)
	interact_component.stop_interact.connect(_stop_interacting_signal)
	interact_component.remove_after_interact = true
	
func _physics_process(delta: float) -> void:
	pass

#region Interaction Signal Handling
func _interaction_signal(interactor: Player) -> void:
	_pick_up(interactor)

func _stop_interacting_signal():
	pass
#endregion

#region Pick up
func _pick_up(_interactor):
	print_debug(self, " ", equip_slot)
	match equip_slot:
		Equip_Slot.HEAD: # Head Slot
			if !Global.player_inventory.head_equip:
				reparent(Global.player_inventory.head_equip_node)
				Global.player_inventory.set_head_equip(self)
				set_physics_process(false)
				interact_component.set_deferred("monitoring", false)
				global_position = get_parent().global_position
				hitbox.disabled = true
				self.visible = false
				enable_function_on_pickup()
		Equip_Slot.BODY: # Body Slot
			if !Global.player_inventory.body_equip:
				reparent(Global.player_inventory.body_equip_node)
				Global.player_inventory.set_body_equip(self)
				set_physics_process(false)
				interact_component.set_deferred("monitoring", false)
				global_position = get_parent().global_position
				hitbox.disabled = true
				self.visible = false
				enable_function_on_pickup()
			else:
				pass # TODO: If if feels better to auto stow a new item on pickup if active is full then do that here
		pass
		Equip_Slot.FOOT: # Feet Slot
			if !Global.player_inventory.foot_equip:
				pass
		Equip_Slot.CHARM: # Charm Slot
			if !Global.player_inventory.charm_equip:
				pass
				
func enable_function_on_pickup():
	printerr(self, " this item does not do anything because the player isn't getting anything here")
#endregion
