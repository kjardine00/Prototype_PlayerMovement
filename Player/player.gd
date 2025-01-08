extends CharacterBody2D
class_name Player

#region Node References
@onready var sprite_2d: Sprite2D = $Sprite2D
#@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var state_machine: State_Machine = $StateMachine
@onready var coyote_timer: Timer = $Timers/CoyoteTimer
@onready var jump_buffer: Timer = $Timers/JumpBuffer
@onready var wall_kick_left: RayCast2D = $RayCasts/WallJump/WallKickLeft
@onready var wall_kick_right: RayCast2D = $RayCasts/WallJump/WallKickRight

#endregion

@export_category("Connect Nodes")
@export var interact_area: Player_Interaction_Area2D
@export var attack_component: Attack_Component

#region Movement Variables
@export_group("Player Movement Properties")
##Horizontal Movement Speed
@export var MOVE_SPEED = 150
##How fast the player gets to top ground H movement speed
@export var ACCELERATION = 40
##How fast the player goes to 0 ground H movement speed
@export var DECELERATION = 50
##How fast the player gets to top air H movement speed
@export var AIR_ACCEL = 15
##How fast the player goes to 0 air H movement speed
@export var AIR_DECEL = 20

##Gravity applied while jumping
@export var GRAVITY_JUMP = 600
##Gravity applied while falling
@export var GRAVITY_FALL = 700
##The faster velocity for falling
@export var MAX_FALL_VEL = 700

##How much the player will jump
@export var JUMP_VELOCITY = -240
@export var JUMP_MULT = 0.5
##Number of jumps the player has
@export var MAX_JUMPS = 1

@export var JUMP_BUFFER_TIME = 0.15
@export var COYOTE_TIME = 0.1

@export var WALL_JUMP_VELOCITY = -190
@export var WALL_JUMP_H_SPEED = 120
@export var WALL_JUMP_Y_SPEED_PEAK = 0
@export var WALL_KICK_ACCEL = 4
@export var WALL_KICK_DECEL = 5
@export var WALL_SLIDE_SPEED = 40

@export var CAN_CLIMB : bool = false
@export var CLIMB_SPEED = 30
@export var CLIMB_ACCEL = 4
@export var CLIMB_DECEL = 5

var jumps_taken = 0
var move_direction_x = 0
var facing = 1
var wall_direction = Vector2.ZERO

@export_group("Abilities Enabled")
@export var WALL_JUMP : bool
@export var WALL_SLIDE: bool
@export var DASH: bool


#endregion

@export_group("Inventory")
@export var INVENTORY: Inv
@export var active_empty : bool = true

#region Input Variables
# Joystick / WASD
var move_up = false
var move_up_tap = false
var move_down = false
var move_down_tap = false
var move_left = false
var move_right = false
# 4 Controller Buttons / LMB SPACE RMB F
var action_left_tap = false
var action_up_tap = false
var action_right_tap = false
var action_down = false
var action_down_tap = false
#endregion

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	
	get_input()
	
	state_machine.current_state.update(delta)
	actions_update(delta)
	handle_max_fall_vel()
	
	move_and_slide()

#region Movement

func h_movement(accel: float = ACCELERATION, decel: float = DECELERATION):
	move_direction_x = Input.get_axis("move_left", "move_right")
	if move_direction_x:
		velocity.x = move_toward(velocity.x, move_direction_x * MOVE_SPEED, accel)
	else: 
		velocity.x = move_toward(velocity.x, move_direction_x * MOVE_SPEED, decel)

func handle_gravity(delta, g: float = GRAVITY_JUMP):
	velocity.y += g * delta

func handle_falling():
	if not is_on_floor():
		coyote_timer.start(COYOTE_TIME)
		state_machine.change_state(state_machine.FALL)
	
func handle_jump():
	if is_on_floor():
		if jumps_taken < MAX_JUMPS:
			if action_down_tap or jump_buffer.time_left > 0:
				jumps_taken += 1
				jump_buffer.stop()
				state_machine.change_state(state_machine.JUMP)
	else:
		if jumps_taken < MAX_JUMPS and jumps_taken > 0 and action_down_tap:
			jumps_taken += 1
			state_machine.change_state(state_machine.JUMP)
		
		if coyote_timer.time_left > 0: 
			if action_down_tap and jumps_taken > 0:
				coyote_timer.stop()
				jumps_taken += 1
				state_machine.change_state(state_machine.JUMP)
	
func handle_landing():
	if is_on_floor():
		jumps_taken = 0
		state_machine.change_state(state_machine.IDLE)
	
func handle_jump_buffer():
	if action_down_tap:
		jump_buffer.start(JUMP_BUFFER_TIME)	
	
func handle_max_fall_vel():
	if velocity.y > MAX_FALL_VEL: velocity.y = MAX_FALL_VEL
	
func handle_wall_jump():
	if WALL_JUMP:
		get_wall_direction()
		if (action_down_tap or jump_buffer.time_left > 0) and (wall_direction != Vector2.ZERO):
			state_machine.change_state(state_machine.WALL_JUMP)
	
func handle_wall_slide():
	if WALL_SLIDE:
		get_wall_direction()
		if (wall_direction == Vector2.LEFT and move_left) or (wall_direction == Vector2.RIGHT and move_right):
			if !action_down:
				state_machine.change_state(state_machine.WALL_SLIDE)

func get_wall_direction():
	if wall_kick_left.is_colliding():
		wall_direction = Vector2.LEFT
	elif wall_kick_right.is_colliding():
		wall_direction = Vector2.RIGHT
	else: 
		wall_direction = Vector2.ZERO
	
func handle_climb():
	if CAN_CLIMB && move_up:
		if !action_down:
			state_machine.change_state(state_machine.CLIMB)
	
func handle_stop_climbing():
	if action_down:
		state_machine.change_state(state_machine.JUMP)
	elif !CAN_CLIMB:
		state_machine.change_state(state_machine.FALL)
	
#endregion

func actions_update(delta):
	## ATTACK: Square, Y, X, LMB
	if action_left_tap:
		if state_machine.current_state != state_machine.WALL_SLIDE:
			handle_attack_action()
	
	## INTERACT: Triangle, X, Y, F
	if action_up_tap:
		handle_interact_action()
		
	## BACK(MENU)/DASH: Circle, A, B, RMB
	if action_right_tap:
		print("CIRCLE")
	
	## JUMP/CONFIRM: X, B, A, SPACE
	if action_down_tap:
		print("X")

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

func handle_attack_action():
	if INVENTORY.active_item:
		attack_component.attack(INVENTORY.active_item)

#endregion

func get_input():
	move_up = Input.is_action_pressed("move_up")
	move_up_tap = Input.is_action_just_pressed("move_up")
	move_down = Input.is_action_pressed("move_down")
	move_down_tap = Input.is_action_just_pressed("move_down")
	move_left = Input.is_action_pressed("move_left")
	move_right = Input.is_action_pressed("move_right")
	action_left_tap = Input.is_action_just_pressed("action_left")
	action_up_tap = Input.is_action_just_pressed("action_up")
	action_right_tap = Input.is_action_just_pressed("action_right")
	action_down = Input.is_action_pressed("action_down")
	action_down_tap = Input.is_action_just_pressed("action_down")
	
	if move_left: facing = -1
	elif move_right: facing = 1
	sprite_2d.flip_h = handle_direction()

func handle_direction():
	return (facing < 0)
