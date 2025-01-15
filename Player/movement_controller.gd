extends Node2D
class_name Movement_Controller

@export var player : Player

var wall_dir = Vector2.ZERO

#region L/R Movement
@export_category("L/R Movement")
##Horizontal Max Movement Speed
@export_range(200, 600) var h_speed : float = 425
##How fast the player gets to top ground H movement speed
@export_range(0, 4) var accel_time : float = 0
##How fast the player goes to 0 ground H movement speed
@export_range(0, 4) var deccel_time : float = 0
#endregion

#region Jumping/Gravity
@export_category("Jumping and Gravity")
##The peak height of the player's jump
@export_range(1, 20
) var jump_height: float = 1.5
##How many jumps the player can do before needing to touch the ground again. Giving more than 1 jump disables jump buffering and coyote time.
@export_range(0, 3) var num_jumps: int = 1
##The strength at which the player will be pulled to the ground.
@export_range(0, 100) var gravity_strength: float = 20.0
##The faster velocity for falling
@export_range(600, 1200) var terminal_velocity = 800
##Your player will move this amount faster when falling providing a less floaty jump curve.
@export_range(0.5, 3) var desc_gravity_factor: float = 2.3
##How much the jump height is cut by.
@export_range(1, 10) var variable_jump_cut_factor: float = 2
##How much extra time (in seconds) the player will be given to jump after falling off an edge. This is set to 0.2 seconds by default.
@export_range(0, 0.5) var coyote_time: float = 0.2
##The window of time (in seconds) that the player can press the jump button before hitting the ground and still have their input registered as a jump. This is set to 0.2 seconds by default.
@export_range(0, 0.5) var jump_buffer_time: float = 0.2
#endregion

#region Wall Jumping
@export_category("Wall Jumping")
##How long the player's movement input will be ignored after wall jumping.
@export_range(0, 0.5) var input_pause_after_wall_jump: float = 0.1
##The angle at which your player will jump away from the wall. 0 is straight away from the wall, 90 is straight up. Does not account for gravity
@export_range(35, 70) var wall_kick_angle: float = 45.0
##The player's gravity will be divided by this number when touch a wall and descending. Set to 1 by default meaning no change will be made to the gravity and there is effectively no wall sliding. THIS IS OVERRIDDED BY WALL LATCH.
@export_range(1, 5) var wall_slide_gravity: float = 3
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
@export var corner_cutting: bool = true
##How many pixels the player will be pushed (per frame) if corner cutting is needed to correct a jump.
@export_range(1, 5) var corner_correction: float = 1.5
##Raycast used for corner cutting calculations. Place above and to the left of the players head point up. ALL ARE NEEDED FOR IT TO WORK.
@export var L_raycast: RayCast2D
##Raycast used for corner cutting calculations. Place above of the players head point up. ALL ARE NEEDED FOR IT TO WORK.
@export var M_raycast: RayCast2D
##Raycast used for corner cutting calculations. Place above and to the right of the players head point up. ALL ARE NEEDED FOR IT TO WORK.
@export var R_raycast: RayCast2D
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
var applied_gravity: float
var max_speed_locked: float
var applied_terminal_vel: float

var acceleration: float
var deceleration: float
var instant_accel: bool = false
var instant_stop: bool = false

var jump_strength: float = 500.0
var jump_count: int

var jump_was_pressed: bool = false
var coyote_active: bool = false
var gravity_active: bool = true

var dashMagnitude: float
var dashCount: int
var dashing: bool = false
var rolling: bool = false

var wall_slide_speed = gravity / wall_slide_gravity

var twoWayDashHorizontal
var twoWayDashVertical
var eightWayDash

var h_direction = 1
var movementInputMonitoring: Vector2 = Vector2(true, true) #movementInputMonitoring.x addresses right direction while .y addresses left direction
var x_move_axis

#endregion

func _ready() -> void:
	_update_data()

func _update_data():
	acceleration = h_speed / accel_time
	deceleration = -h_speed / deccel_time
	
	jump_strength = (10.0 * jump_height) * gravity_strength
	jump_count = num_jumps
	
	dashMagnitude = h_speed * DASH_LENGTH
	dashCount = DASHES
	
	max_speed_locked = h_speed
	
	#region Divide by 0 protection
	if accel_time == 0:
		instant_accel = true
		accel_time = 1
	elif accel_time < 0:
		accel_time = abs(accel_time)
		instant_accel = false
	else:
		instant_accel = false
		
	if deccel_time == 0:
		instant_stop = true
		deccel_time = 1
	elif accel_time < 0:
		accel_time = abs(accel_time)
		instant_stop = false
	else:
		instant_stop = false
	#endregion
	
	if num_jumps > 1:
		jump_buffer_time = 0
		coyote_time = 0
	
	jump_buffer_time = abs(jump_buffer_time)
	coyote_time = abs(coyote_time)
	
	#region decide on dash type
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
	#endregion
	
func _physics_process(delta: float) -> void:
	_gravity()
	_horizontal_movement(delta)
	_handle_jumping()
	
	player.move_and_slide()

#region Always applying to the player
## Apply gravity to the player checking conditions
func _gravity():
	if player.velocity.y > 0:
		applied_gravity = gravity_strength * desc_gravity_factor
	else: 
		applied_gravity = gravity_strength

	if player.is_on_wall():
		jump_count = num_jumps
		applied_terminal_vel = terminal_velocity / wall_slide_gravity
		if wall_slide_gravity != 1 and player.velocity.y > 0:
			applied_gravity = applied_gravity / wall_slide_gravity
	elif !player.is_on_wall():
		applied_terminal_vel = terminal_velocity
	
	if gravity_active:
		if player.velocity.y < applied_terminal_vel:
			player.velocity.y += applied_gravity
		elif player.velocity.y > applied_terminal_vel:
			player.velocity.y = applied_terminal_vel

func _horizontal_movement(delta):
	## if player is holding both directions
	if player.input_controller.right_hold and player.input_controller.left_hold:
		_decelerate(delta)
	## if player is moving L/R
	elif player.input_controller.right_hold and movementInputMonitoring:
		_accelerate(delta, 1)
		if player.velocity.x < 0:
			_decelerate(delta)
	elif player.input_controller.left_hold and movementInputMonitoring:
		_accelerate(delta, -1)
		if player.velocity.x > 0:
			_decelerate(delta)
	## if the player holds neither directions
	if !(player.input_controller.left_hold or player.input_controller.right_hold):
		_decelerate(delta)
	
	if player.velocity.x > 0:
		h_direction = 1
	elif player.velocity.x < 0:
		h_direction = -1
		
	#if rightTap:
		#wasPressingR = true
	#if leftTap:
		#wasPressingR = false

func _accelerate(delta, dir):
	if abs(player.velocity.x) > h_speed or instant_accel:
		player.velocity.x = h_speed * dir
	else: 
		player.velocity.x += acceleration * delta * dir

func _decelerate(delta):
	if !instant_stop:
		if (abs(player.velocity.x) > 0) and (abs(player.velocity.x) <= abs(deceleration * delta)) and movementInputMonitoring:
			player.velocity.x = 0 
		elif player.velocity.x > 0:
			player.velocity.x += deceleration * delta
		elif player.velocity.x < 0:
			player.velocity.x -= deceleration * delta
	else:
		player.velocity.x = 0
#endregion

func _handle_jumping():
	#Short hop function
	if player.input_controller.action_down_release and player.velocity.y < 0:
		player.velocity.y = player.velocity.y / variable_jump_cut_factor
	
	if jump_count == 1:
		if !player.is_on_floor() and !player.is_on_wall():
			print("jump here")
			if coyote_time > 0:
				coyote_active = true
				_coyote_time()
		
		if player.input_controller.action_down_press and !player.is_on_wall():
			if coyote_active:
				coyote_active = true
				_jump()
			if jump_buffer_time > 0:
				jump_was_pressed = true
				_buffer_jump()
			elif jump_buffer_time == 0 and coyote_time == 0 and player.is_on_floor():
				_jump()
		elif player.input_controller.action_down_press and player.is_on_wall() and !player.is_on_floor():
			_wall_jump()
		elif player.input_controller.action_down_press:
			_jump()

	if player.is_on_floor():
		jump_count = num_jumps
		if coyote_time > 0:
			coyote_active = true
		else:
			coyote_active = false
		if jump_was_pressed:
			_jump()
			
	elif jump_count > 1:
		if player.is_on_floor():
			jump_count = num_jumps
		if player.input_controller.action_down_press and jump_count > 0:
			player.velocity.y = - jump_strength
			jump_count -= 1

func _jump():
	if jump_count > 0:
		
		player.velocity.y = -jump_strength
		jump_count += -1
		print("reg jump" + str(player.movement_controller.jump_count))
		##TODO investigate this next line and if I need it
		jump_was_pressed = false

func _wall_jump():
	if player.WALL_JUMP:
		
		var h_wall_kick = abs(jump_strength * cos(wall_kick_angle * (PI / 180)))
		var v_wall_kick = abs(jump_strength * sin(wall_kick_angle * (PI / 180)))
		
		player.velocity.y = -v_wall_kick
		player.velocity.x = -h_wall_kick * h_direction
		
		jump_count += -1
		
		if input_pause_after_wall_jump != 0:
			movementInputMonitoring = Vector2(false, false)
			_input_pause_reset(input_pause_after_wall_jump)

#region Timers
func _input_pause_reset(time):
	await get_tree().create_timer(time).timeout
	movementInputMonitoring = Vector2(true, true)

func _buffer_jump():
	await get_tree().create_timer(jump_buffer_time).timeout
	jump_was_pressed = false

func _coyote_time():
	await get_tree().create_timer(coyote_time).timeout
	coyote_active = false
	jump_count += -1
#endregion

func _corner_cutting():
	if corner_cutting:
		pass
		if player.velocity.y < 0 and L_raycast.is_colliding() and !R_raycast.is_colliding() and !M_raycast.is_colliding():
			player.position.x += corner_correction
		if player.velocity.y < 0 and !L_raycast.is_colliding() and R_raycast.is_colliding() and !M_raycast.is_colliding():
			player.position.x -= corner_correction




##=================PREVIOUS==CODE=================================================================

#func handle_climb():
	#if player.CAN_CLIMB && player.input_controller.up_hold:
		#if !player.input_controller.action_down:
			#player.state_machine.change_state(player.state_machine.CLIMB)
	#
#func handle_stop_climbing():
	#if player.input_controller.action_down:
		#player.state_machine.change_state(player.state_machine.JUMP)
	#elif !player.CAN_CLIMB:
		#player.state_machine.change_state(player.state_machine.FALL)
