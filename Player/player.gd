extends CharacterBody2D
class_name Player

@onready var hitbox: CollisionShape2D = $Hitbox
@onready var camera_2d: Camera2D = $Camera2D

@export_category("Connect Nodes")
@export var movement_handler: MovementHandler
@export var anim_controller: Animation_Controller
@export var inv_controller: Inventory_Controller
@export var interact_area: Player_Interaction_Area2D
#@export var attack_component: Attack_Component
@export var state_machine: State_Machine

@export_category("Properties")
@export var max_jumps : int = 1
@export var num_of_available_jumps : int

#region Apply Ability type
@export_category("Body Equipment Abilities")
@export_enum ("ROLL", "DASH", "GLIDE", "BLINK", "FLY", "BARRIER") var active_body_equip_ability : int = 0

var ROLL = false
var DASH = false
var GLIDE = false
var BLINK = false
var FLY = false
var BARRIER = false

func update_body_equip_ability():
	ROLL = false
	DASH = false
	GLIDE = false
	BLINK = false
	FLY = false
	BARRIER = false
	match active_body_equip_ability:
		0:
			ROLL = true
		1:
			DASH = true
		2:
			GLIDE = true
		3:
			BLINK = true
		4:
			FLY = true
		5:
			BARRIER = true
		6:
			pass
#endregion

func _ready() -> void:
	reset_num_jumps()
	
	InputHandler.movement_input.connect(on_movement_input)
	InputHandler.jump.connect(on_jump_input)
	InputHandler.jump_released.connect(on_jump_released_input)
	InputHandler.interact.connect(func(): interact_area.interact(self))
	InputHandler.attack.connect(on_attack_input)
	InputHandler.swap_active.connect(on_swap_active_input)
	InputHandler.throw_drop.connect(on_throw_drop_input)
	InputHandler.use_ability.connect(on_use_ability_input)
	InputHandler.use_charm.connect(on_use_charm_input)

func _physics_process(delta: float) -> void:
	state_machine.current_state.update(delta)

func reset_num_jumps():
	num_of_available_jumps = max_jumps
	
#region Handle Inputs
func on_movement_input(direction):
	state_machine.handle_movement_input(direction)
	anim_controller.handle_direction(direction.x)

func on_jump_input():
	state_machine.handle_jump_input()
	
func on_jump_released_input():
	state_machine.handle_jump_released()

func on_attack_input(direction):
	inv_controller.handle_attack_input(direction)

func on_swap_active_input():
	inv_controller.swap_active()

func on_throw_drop_input(direction):
	inv_controller.handle_throw_drop(direction)
	
func on_use_ability_input():
	inv_controller.handle_ability_input()
	
func on_use_charm_input():
	print_debug("Charm Used")
	pass
#endregion

#region EnvironmentObjDetector
func _on_environment_obj_detector_body_entered(body: Node2D) -> void:
	if body.is_in_group("env_object"):
		print(str(body))
		self.set_collision_mask_value(3, true)

func _on_environment_obj_detector_body_exited(body: Node2D) -> void:
	if body.is_in_group("env_object"):
		self.set_collision_mask_value(3, false)
#endregion
