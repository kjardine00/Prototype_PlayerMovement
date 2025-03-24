extends CharacterBody2D
class_name Equipment

@export_category("Connections")
@export var interact_component : InteractComponent
@export var hitbox : CollisionShape2D
@export var sprite: Sprite2D

@export_category("Properties")
@export_enum("Head", "Body", "Foot", "Charm") var equip_slot : int

@export_group("UI Elements")
## Must be a square icon with dimensions 0x0 px
@export var icon : Texture

func _ready() -> void:
	interact_component.interact.connect(_interaction_signal)
	interact_component.stop_interact.connect(_stop_interacting_signal)
	
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
	match equip_slot:
		0: # Head Slot
			if !Global.player_inventory.head_equip:
				reparent(Global.player_inventory.head_equip_node)
				Global.player_inventory.set_head_equip(self)
				set_physics_process(false)
				global_position = get_parent().global_position
				hitbox.disabled = true
				self.visible = false
				enable_function_on_pickup()
				print("state function calling enable function")
		1: # Body Slot
			if !Global.player_inventory.body_equip:
				reparent(Global.player_inventory.body_equip_node)
				Global.player_inventory.set_body_equip(self)
				set_physics_process(false)
				global_position = get_parent().global_position
				hitbox.disabled = true
				self.visible = false
				enable_function_on_pickup()
				print("state function calling enable function")
			else:
				pass # TODO: If if feels better to auto stow a new item on pickup if active is full then do that here
		pass
		2: # Feet Slot
			if !Global.player_inventory.foot_equip:
				pass
		3: # Charm Slot
			if !Global.player_inventory.charm_equip:
				pass
				
func enable_function_on_pickup():
	printerr(self, " this item does not do anything because the player isn't getting anything here")
#endregion
