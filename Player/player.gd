extends CharacterBody2D
class_name Player

@onready var hitbox: CollisionShape2D = $Hitbox
@onready var camera_2d: Camera2D = $Camera2D

@export_category("Connect Nodes")
@export var movement_handler: MovementHandler
@export var anim_controller: Animation_Controller
@export var inv_controller: Inventory_Controller
@export var interact_area: Player_Interaction_Area2D
@export var state_machine: State_Machine
@export var wall_detector: RayCast2D

@export_category("Properties")
@export var max_jumps : int = 1
@export var num_of_available_jumps : int
var last_direction : Vector2 = Vector2.ZERO

@export_category("Boolean Modifiers")
@export var wall_jump : bool = false

#region Apply Ability type
@export_category("Equipment Abilities")
@export_group("Head")
@export var head_ability : HeadEquip.AbilityType
@export_group("Body")
@export var body_ability : BodyEquip.AbilityType = BodyEquip.AbilityType.ROLL
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
	
	inv_controller.enable_head_ability.connect(handle_enable_head_ability)
	inv_controller.enable_body_ability.connect(handle_enable_body_ability)

func _physics_process(delta: float) -> void:
	state_machine.current_state.update(delta)

func reset_num_jumps():
	num_of_available_jumps = max_jumps

#region Handle Inputs
func on_movement_input(direction):
	state_machine.handle_movement_input(direction)
	anim_controller.handle_direction(direction.x)
	
	if direction.x > 0:
		wall_detector.target_position.x = 50	
		last_direction = Vector2.RIGHT
	elif direction.x < 0: 
		wall_detector.target_position.x = -50
		last_direction = Vector2.LEFT

func on_jump_input():
	state_machine.handle_jump_input()
	#
func on_jump_released_input():
	state_machine.handle_jump_released()

func on_attack_input(direction, last_horizontal_direction):
	inv_controller.handle_attack_input(direction, last_horizontal_direction)

func on_swap_active_input():
	inv_controller.swap_active()

func on_throw_drop_input(direction):
	inv_controller.handle_throw_drop(direction)
	
func on_use_ability_input(last_horizontal_direction):
	state_machine.handle_ability_input(body_ability, last_horizontal_direction)
	
func on_use_charm_input(_direction):
	print_debug("Charm Used")
	pass
#endregion

#region Enable / Disable Abilities
func handle_enable_head_ability(ability: HeadEquip.AbilityType):
	head_ability = ability
	
func handle_enable_body_ability(ability: BodyEquip.AbilityType):
	body_ability = ability
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
