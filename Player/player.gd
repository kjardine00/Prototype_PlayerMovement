extends CharacterBody2D
class_name Player

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var state_machine: State_Machine = $StateMachine
@onready var coyote_timer: Timer = $Timers/CoyoteTimer
@onready var jump_buffer: Timer = $Timers/JumpBuffer
@onready var wall_kick_left: RayCast2D = $RayCasts/WallJump/WallKickLeft
@onready var wall_kick_right: RayCast2D = $RayCasts/WallJump/WallKickRight

#region Player Variables
@export_category("Player Properties")
@export var MOVE_SPEED = 350
@export var ACCELERATION = 50
@export var DECELERATION = 100
@export var AIR_ACCEL = 50
@export var AIR_DECEL = 120

@export var GRAVITY_JUMP = 600
@export var GRAVITY_FALL = 700
@export var MAX_FALL_VEL = 700

@export var JUMP_VELOCITY = -240
@export var JUMP_MULT = 0.5
@export var MAX_JUMPS = 1

@export var JUMP_BUFFER_TIME = 0.15
@export var COYOTE_TIME = 0.1

@export var WALL_JUMP_VELOCITY = -170
@export var WALL_JUMP_H_SPEED = MOVE_SPEED * .7
@export var WALL_JUMP_Y_SPEED_PEAK = 0
@export var WALL_KICK_ACCEL = 4
@export var WALL_KICK_DECEL = 5
@export var WALL_SLIDE_SPEED = 40

var jumps_taken = 0
var move_direction_x = 0
var facing = 1
var wall_direction = Vector2.ZERO

@export_category("Abilities Enabled")
@export var WALL_JUMP : bool
@export var WALL_SLIDE: bool
@export var DASH: bool

@export_category("Connect Nodes")

#endregion

#region Input Variables
var move_up = false
var move_down = false
var move_left = false
var move_right = false
var action_down = false
var action_down_pressed = false
#endregion

func _ready() -> void:
	await state_machine.ready

func _physics_process(delta: float) -> void:
	get_input()
	
	state_machine.current_state.update(delta)
	handle_max_fall_vel()
	
	move_and_slide()

#region Player Movement

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
			if action_down_pressed or jump_buffer.time_left > 0:
				jumps_taken += 1
				jump_buffer.stop()
				state_machine.change_state(state_machine.JUMP)
	else:
		if jumps_taken < MAX_JUMPS and jumps_taken > 0 and action_down_pressed:
			jumps_taken += 1
			state_machine.change_state(state_machine.JUMP)
		
		if coyote_timer.time_left > 0: 
			if action_down_pressed and jumps_taken > 0:
				coyote_timer.stop()
				jumps_taken += 1
				state_machine.change_state(state_machine.JUMP)
	
func handle_landing():
	if is_on_floor():
		jumps_taken = 0
		state_machine.change_state(state_machine.IDLE)
	
func handle_jump_buffer():
	if action_down_pressed:
		jump_buffer.start(JUMP_BUFFER_TIME)	
	
func handle_max_fall_vel():
	if velocity.y > MAX_FALL_VEL: velocity.y = MAX_FALL_VEL
	
func handle_wall_jump():
	if WALL_JUMP:
		get_wall_direction()
		if (action_down_pressed or jump_buffer.time_left > 0) and (wall_direction != Vector2.ZERO):
			state_machine.change_state(state_machine.WALL_JUMP)
	
func handle_wall_slide():
	if WALL_SLIDE:
		if (wall_direction == Vector2.LEFT and move_left) or (wall_direction == Vector2.RIGHT and move_right):
			if not action_down:
				state_machine.change_state(state_machine.WALL_SLIDE)

#endregion

func get_wall_direction():
	if wall_kick_left.is_colliding():
		wall_direction = Vector2.LEFT
	elif wall_kick_right.is_colliding():
		wall_direction = Vector2.RIGHT
	else: 
		wall_direction = Vector2.ZERO

func get_input():
	move_up = Input.is_action_pressed("move_up")
	move_down = Input.is_action_pressed("move_down")
	move_left = Input.is_action_pressed("move_left")
	move_right = Input.is_action_pressed("move_right")
	action_down = Input.is_action_pressed("action_down")
	action_down_pressed = Input.is_action_just_pressed("action_down")
	
	if move_left: facing = -1
	elif move_right: facing = 1
	sprite_2d.flip_h = (facing < 0)

func handle_flip_h():
	sprite_2d.flip_h = (facing  < 1)
