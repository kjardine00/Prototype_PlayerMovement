extends Node2D
class_name Movement_Controller

@export var player : Player

@onready var coyote_timer: Timer = $CoyoteTimer
@onready var jump_buffer: Timer = $JumpBuffer

#region L/R Movement
@export_category("L/R Movement")
##Horizontal Max Movement Speed
@export_range(100, 1000) var MAX_SPEED : float = 500
##How fast the player gets to top ground H movement speed
@export_range(0, 4) var TIME_TO_REACH_MAX_SPEED : float = .2
##How fast the player goes to 0 ground H movement speed
@export_range(0, 4) var TIME_TO_REACH_ZERO_SPEED : float = .2
#endregion

#region Jumping/Gravity
@export_category("Jumping and Gravity")
##The peak height of the player's jump
@export_range(1, 100) var JUMP_HEIGHT: float = 2.0
##How many jumps the player can do before needing to touch the ground again. Giving more than 1 jump disables jump buffering and coyote time.
@export_range(0, 3) var NUM_JUMPS: int = 1
##The strength at which the player will be pulled to the ground.
@export_range(0, 100) var gravityScale: float = 20.0
##The faster velocity for falling
@export_range(0, 1000) var MAX_FALL_VEL = 500
##Your player will move this amount faster when falling providing a less floaty jump curve.
@export_range(0.5, 3) var DESC_GRAVITY_FACTOR: float = 1.3
##Enabling this toggle makes it so that when the player releases the jump key while still ascending, their vertical velocity will cut by the height cut, providing variable jump height.
@export var VAR_JUMP_HEIGHT: bool = true
##How much the jump height is cut by.
@export_range(1, 10) var JUMP_VAR: float = 2
##How much extra time (in seconds) the player will be given to jump after falling off an edge. This is set to 0.2 seconds by default.
@export_range(0, 0.5) var COYOTE_TIME: float = 0.2
##The window of time (in seconds) that the player can press the jump button before hitting the ground and still have their input registered as a jump. This is set to 0.2 seconds by default.
@export_range(0, 0.5) var JUMP_BUFFERING: float = 0.2
#endregion

#region Wall Jumping
@export_category("Wall Jumping")
##Allows your player to jump off of walls. Without a Wall Kick Angle, the player will be able to scale the wall.
@export var WALL_JUMP: bool = false
##How long the player's movement input will be ignored after wall jumping.
@export_range(0, 0.5) var INPUT_PAUSE_AFTER_WALL_JUMP: float = 0.1
##The angle at which your player will jump away from the wall. 0 is straight away from the wall, 90 is straight up. Does not account for gravity
@export_range(0, 90) var WALL_KICK_ANGLE: float = 60.0
##The player's gravity will be divided by this number when touch a wall and descending. Set to 1 by default meaning no change will be made to the gravity and there is effectively no wall sliding. THIS IS OVERRIDDED BY WALL LATCH.
@export_range(1, 20) var WALL_SLIDING: float = 1.0
##If enabled, the player's gravity will be set to 0 when touching a wall and descending. THIS WILL OVERRIDE WALLSLIDING.
@export var WALL_LATCHING: bool = false
#endregion

#region Dashing
@export_category("Dashing")
##The type of dashes the player can do.
@export_enum("None", "Horizontal", "Vertical", "Four Way", "Eight Way") var DASH_TYPE: int
##How many dashes the player can do before needing to hit the ground.
@export_range(0, 10) var DASHES: int = 1
##If enabled, pressing the opposite direction of a dash, during a dash, will zero the player's velocity.
@export var DASH_CANCEL: bool = true
##How far the player will dash. One of the dashing toggles must be on for this to be used.
@export_range(1.5, 4) var DASH_LENGTH: float = 2.5
#endregion

#region Corner Cutting/Jump Correction
@export_category("Corner Cutting/Jump Correct")
##If the player's head is blocked by a jump but only by a little, the player will be nudged in the right direction and their jump will execute as intended.
@export var ENABLE_CORNER_CUTTING: bool = false
##How many pixels the player will be pushed (per frame) if corner cutting is needed to correct a jump.
@export_range(1, 5) var CORRECTION_AMOUNT: float = 1.5
##Raycast used for corner cutting calculations. Place above and to the left of the players head point up. ALL ARE NEEDED FOR IT TO WORK.
@export var L_Raycast: RayCast2D
##Raycast used for corner cutting calculations. Place above of the players head point up. ALL ARE NEEDED FOR IT TO WORK.
@export var M_Raycast: RayCast2D
##Raycast used for corner cutting calculations. Place above and to the right of the players head point up. ALL ARE NEEDED FOR IT TO WORK.
@export var R_Raycast: RayCast2D
#endregion

#region Down Input
@export_category("Down Input")
##Holding down will crouch the player. Crouching script may need to be changed depending on how your player's size proportions are. It is built for 32x player's sprites.
@export var CROUCH: bool = false
##Holding down and pressing the input for "roll" will execute a roll if the player is grounded. Assign a "roll" input in project settings input.
@export var CAN_ROLL: bool
@export_range(1.25, 2) var ROLL_LENGTH: float = 2
#endregion

#region Set Variables
#Variables determined by the developer set ones.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var maxSpeedLock: float
var appliedTerminalVelocity: float

var friction: float
var acceleration: float
var deceleration: float
var instantAccel: bool = false
var instantStop: bool = false

var jumpMagnitude: float = 500.0
var jumpCount: int
var jumpWasPressed: bool = false
var coyoteActive: bool = false
var dashMagnitude: float
var gravityActive: bool = true
var dashing: bool = false
var dashCount: int
var rolling: bool = false

var twoWayDashHorizontal
var twoWayDashVertical
var eightWayDash

var wasMovingR: bool
var wasPressingR: bool
var movementInputMonitoring: Vector2 = Vector2(true, true) #movementInputMonitoring.x addresses right direction while .y addresses left direction
var x_move_axis

var latched
var wasLatched
var crouching
var groundPounding

#endregion

func _ready() -> void:
	_update_data()

func _update_data():
	acceleration = MAX_SPEED / TIME_TO_REACH_MAX_SPEED
	deceleration = -MAX_SPEED / TIME_TO_REACH_ZERO_SPEED
	
	jumpMagnitude = (10.0 * JUMP_HEIGHT) * gravityScale
	jumpCount = NUM_JUMPS
	
	dashMagnitude = MAX_SPEED * DASH_LENGTH
	dashCount = DASHES
	
	maxSpeedLock = MAX_SPEED
	
	#animScaleLock = abs(anim.scale)
	#colliderScaleLockY = col.scale.y
	#colliderPosLockY = col.position.y
	
	if TIME_TO_REACH_MAX_SPEED == 0:
		instantAccel = true
		TIME_TO_REACH_MAX_SPEED = 1
	elif TIME_TO_REACH_MAX_SPEED < 0:
		TIME_TO_REACH_MAX_SPEED = abs(TIME_TO_REACH_MAX_SPEED)
		instantAccel = false
	else:
		instantAccel = false
		
	if TIME_TO_REACH_ZERO_SPEED == 0:
		instantStop = true
		TIME_TO_REACH_ZERO_SPEED = 1
	elif TIME_TO_REACH_MAX_SPEED < 0:
		TIME_TO_REACH_MAX_SPEED = abs(TIME_TO_REACH_MAX_SPEED)
		instantStop = false
	else:
		instantStop = false
		
	if NUM_JUMPS > 1:
		JUMP_BUFFERING = 0
		COYOTE_TIME = 0
	
	JUMP_BUFFERING = abs(JUMP_BUFFERING)
	COYOTE_TIME = abs(COYOTE_TIME)
	
	twoWayDashHorizontal = false
	twoWayDashVertical = false
	eightWayDash = false
	if DASH_TYPE == 0:
		pass
	if DASH_TYPE == 1:
		twoWayDashHorizontal = true
	elif DASH_TYPE == 2:
		twoWayDashVertical = true
	elif DASH_TYPE == 3:
		twoWayDashHorizontal = true
		twoWayDashVertical = true
	elif DASH_TYPE == 4:
		eightWayDash = true

func _physics_process(delta: float) -> void:
	handle_max_fall_vel()
	player.move_and_slide()

func h_movement(delta, accel: float = acceleration, decel: float = deceleration):
	if player.input_controller.right_hold and player.input_controller.left_hold:
		if !instantStop:
			_decelerate(delta, false)
		else:
			player.velocity.x = -0.1
	elif player.input_controller.right_hold:
		if player.velocity.x > MAX_SPEED or instantAccel:
			player.velocity.x = MAX_SPEED
		else: 
			player.velocity.x += acceleration * delta
		if player.velocity.x < 0:
			if !instantStop:
				_decelerate(delta, false)
			else:
				player.velocity.x = -0.1
	elif player.input_controller.left_hold:
		if player.velocity.x < -MAX_SPEED or instantAccel:
			player.velocity.x = -MAX_SPEED
		else:
			player.velocity.x -= acceleration * delta
		if player.velocity.x > 0:
			if !instantStop:
				_decelerate(delta, false)
			else:
				player.velocity.x = 0.1
	
	if !(player.input_controller.left_hold or player.input_controller.right_hold):
		if !instantStop:
			_decelerate(delta, false)
		else:
			player.velocity.x = 0
			
	#if player.input_controller.h_move_axis:
		#player.velocity.x = move_toward(player.velocity.x, player.input_controller.h_move_axis * MAX_SPEED, accel)
	#else: 
		#player.velocity.x = move_toward(player.velocity.x, player.input_controller.h_move_axis * MAX_SPEED, decel)
		
func _decelerate(delta, vertical: bool):
	if !vertical:
		if (abs(player.velocity.x) > 0) and (abs(player.velocity.x) <= abs(deceleration * delta)):
			player.velocity.x = 0 
		elif player.velocity.x > 0:
			player.velocity.x += deceleration * delta
		elif player.velocity.x < 0:
			player.velocity.x -= deceleration * delta
	elif vertical and player.velocity.y > 0:
		player.velocity.y += deceleration * delta
	
func handle_gravity(delta, g: float = gravity):
	player.velocity.y += g * delta

func handle_falling():
	if not player.is_on_floor():
		coyote_timer.start(COYOTE_TIME)
		player.state_machine.change_state(player.state_machine.FALL)
	
func handle_jump():
	if player.is_on_floor():
		if jumpCount > 0:
			if player.input_controller.action_down_press or jump_buffer.time_left > 0:
				jump_buffer.stop()
				player.state_machine.change_state(player.state_machine.JUMP)
	else:
		if jumpCount > 0 and player.input_controller.action_down_press:
			player.state_machine.change_state(player.state_machine.JUMP)
		
		if coyote_timer.time_left > 0: 
			if player.input_controller.action_down_press and jumpCount > 0:
				coyote_timer.stop()
				player.state_machine.change_state(player.state_machine.JUMP)

func jump():
	player.velocity.y = -jumpMagnitude
	jumpCount += -1
	
func handle_landing():
	if player.is_on_floor():
		jumpCount = NUM_JUMPS
		player.state_machine.change_state(player.state_machine.IDLE)
	
func handle_jump_buffer():
	if player.input_controller.action_down_press:
		jump_buffer.start(JUMP_BUFFERING)	
	
func handle_max_fall_vel():
	if player.velocity.y > MAX_FALL_VEL: player.velocity.y = MAX_FALL_VEL
	
func handle_wall_jump():
	if WALL_JUMP:
		get_wall_direction()
		if (player.input_controller.action_down_press or jump_buffer.time_left > 0) and (player.wall_direction != Vector2.ZERO):
			player.state_machine.change_state(player.state_machine.WALL_JUMP)
	
func handle_wall_slide():
	if player.WALL_SLIDE:
		get_wall_direction()
		if (player.wall_direction == Vector2.LEFT and player.input_controller.left_hold) or (player.wall_direction == Vector2.RIGHT and player.input_controller.right_hold):
			if !player.input_controller.action_down:
				player.state_machine.change_state(player.state_machine.WALL_SLIDE)

func get_wall_direction():
	if player.wall_kick_left.is_colliding():
		player.wall_direction = Vector2.LEFT
	elif player.wall_kick_right.is_colliding():
		player.wall_direction = Vector2.RIGHT
	else: 
		player.wall_direction = Vector2.ZERO
	
func handle_climb():
	if player.CAN_CLIMB && player.input_controller.up_hold:
		if !player.input_controller.action_down:
			player.state_machine.change_state(player.state_machine.CLIMB)
	
func handle_stop_climbing():
	if player.input_controller.action_down:
		player.state_machine.change_state(player.state_machine.JUMP)
	elif !player.CAN_CLIMB:
		player.state_machine.change_state(player.state_machine.FALL)
