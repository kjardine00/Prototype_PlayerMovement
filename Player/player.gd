extends CharacterBody2D
class_name Player

@onready var hitbox: CollisionShape2D = $Hitbox

@export_category("Connect Nodes")
@export var movement_controller: Movement_Controller
@export var anim_controller: Animation_Controller
@export var input_controller: Input_Controller
@export var inv_controller: Inventory_Controller
@export var interact_area: Player_Interaction_Area2D
@export var attack_component: Attack_Component
@export var state_machine: State_Machine

#region Depreciated Movement Variables
@export_category("Movement Variables to be depreciated/refactored")
#@export var CAN_CLIMB : bool = false
#@export var CLIMB_SPEED = 30
#@export var CLIMB_ACCEL = 4
#@export var CLIMB_DECEL = 5
#endregion

var h_dir

@export_category("Body Equipment Abilities")
@export_enum ("ROLL", "DASH", "GLIDE", "BLINK", "FLY", "BARRIER") var active_body_equip_ability : int = 0

#region decide on dash type
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
	input_controller.direction.connect(_send_direction_controllers)

func _physics_process(_delta: float) -> void:
	#state_machine.current_state.update(delta)
	pass

func _send_direction_controllers(direction):
	h_dir = direction
	anim_controller.facing = direction
	inv_controller.facing = direction

#region Interact Logic
func handle_interact_action():
	interact_area.interact(self)
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
