extends CharacterBody2D
class_name Player

@export_category("Connect Nodes")
@export var movement_controller: Movement_Controller
@export var anim_controller: Animation_Controller
@export var input_controller: Input_Controller
@export var interact_area: Player_Interaction_Area2D
@export var attack_component: Attack_Component
@export var state_machine: State_Machine

#region Movement Variables
@export_category("Movement Variables to be depreciated/refactored")
#@export var CAN_CLIMB : bool = false
#@export var CLIMB_SPEED = 30
#@export var CLIMB_ACCEL = 4
#@export var CLIMB_DECEL = 5

var jumps_taken = 0
var move_direction_x = 0
var facing = 1
var wall_direction = Vector2.ZERO
#endregion

@export_group("Abilities Enabled")
@export var ROLL: bool
@export var WALL_JUMP : bool = true
@export var DASH: bool

@export_group("Inventory")
##TODO Might need to be in its own node
@export var INVENTORY: Inv
@export var active_empty : bool = true

func _ready() -> void:
	input_controller.direction.connect(_send_direction_controllers)

func _physics_process(delta: float) -> void:
	#state_machine.current_state.update(delta)
	pass

func _send_direction_controllers(direction):
	anim_controller.facing = direction

#region Inventory Managment

func handle_equip_item(item):
	if INVENTORY.active_item == null: 
		INVENTORY.active_item = item
		
func handle_interact_action():
	if INVENTORY.active_item == null:
		active_empty = true
	else:
		active_empty = false
	interact_area.interact(self)
		

#endregion

#region Attack
## TODO create this controller
func handle_attack_action():
	if INVENTORY.active_item:
		attack_component.attack(INVENTORY.active_item)

#endregion
