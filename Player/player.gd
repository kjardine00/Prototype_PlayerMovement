extends CharacterBody2D
class_name Player

@onready var hitbox: CollisionShape2D = $Hitbox
@onready var inventory_controller: Node2D = $InventoryController

@export_category("Connect Nodes")
@export var movement_controller: Movement_Controller
@export var anim_controller: Animation_Controller
@export var input_controller: Input_Controller
@export var inv_controller: Inventory_Controller
@export var interact_area: Player_Interaction_Area2D
@export var attack_component: Attack_Component
@export var state_machine: State_Machine

#region Movement Variables
@export_category("Movement Variables to be depreciated/refactored")
#@export var CAN_CLIMB : bool = false
#@export var CLIMB_SPEED = 30
#@export var CLIMB_ACCEL = 4
#@export var CLIMB_DECEL = 5

var h_dir
#endregion

@export_category("Abilities Enabled")
@export var ROLL: bool
@export var WALL_JUMP : bool = true
@export var DASH: bool

func _ready() -> void:
	input_controller.direction.connect(_send_direction_controllers)

func _physics_process(_delta: float) -> void:
	#state_machine.current_state.update(delta)
	pass

func _send_direction_controllers(direction):
	h_dir = direction
	anim_controller.facing = direction
	_grab_pos(direction)
	
func _grab_pos(dir):
	if dir == Vector2.LEFT:
		inventory_controller.position.x = -55
	elif dir == Vector2.RIGHT:
		inventory_controller.position.x = 55

#region Interact Logic
func handle_interact_action():
	interact_area.interact(self)
#endregion

#region Attack Btn logic
## TODO create this controller
func handle_attack_action():
	var active_item = inventory_controller.active_item
	
	if active_item:
		if active_item.has_method("attack"):
			active_item.attack()
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
