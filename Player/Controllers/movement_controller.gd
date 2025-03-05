extends Node2D
class_name Movement_Controller

@export var player : Player

var wall_dir = Vector2.ZERO

#region L/R Movement
@export_category("L/R Movement")
##Horizontal Max Movement Speed
@export_range(200, 600) var h_speed : float = 425
##How fast the player gets to top ground H movement speed
@export_range(0, 4) var accel_time : float = 0.1
##How fast the player goes to 0 ground H movement speed
@export_range(0, 4) var deccel_time : float = 0.1

##How long the player will roll for
@export_range(1.25, 4) var roll_duration: float = 3
#endregion

#region Jumping/Gravity
@export_category("Jumping and Gravity")
##The peak height of the player's jump
@export_range(1, 20) var jump_height: float = 5
##How many jumps the player can do before needing to touch the ground again. Giving more than 1 jump disables jump buffering and coyote time.
@export_range(0, 3) var num_jumps: int = 1
##The strength at which the player will be pulled to the ground.
@export_range(0, 100) var gravity_strength: float = 18.0
##The faster velocity for falling
@export_range(600, 1200) var terminal_velocity = 1000
##Your player will move this amount faster when falling providing a less floaty jump curve.
@export_range(0.5, 3) var desc_gravity_factor: float = 2.3
##How much the jump height is cut by.
@export_range(1, 10) var variable_jump_cut_factor: float = 5
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
@export_enum("None", "Horizontal", "Vertical", "Four Way", "Eight Way") var dash_type: int
##How many dashes the player can do before needing to hit the ground.
@export_range(0, 10) var num_dashes: int = 1
##If enabled, pressing the opposite direction of a dash, during a dash, will zero the player's velocity.
@export var dash_cancel: bool = true
##How far the player will dash. One of the dashing toggles must be on for this to be used.
@export_range(1.5, 4) var dash_length: float = 3
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
var dash_count: int
var dashing: bool = false
var rolling: bool = false

var wall_slide_speed = gravity / wall_slide_gravity

var two_way_dash_h
var two_way_dash_v
var eight_way_dash

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
	
	dashMagnitude = h_speed * dash_length
	dash_count = num_dashes
	
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
	two_way_dash_h = false
	two_way_dash_v = false
	eight_way_dash = false
	if dash_type == 0:
		pass
	if dash_type == 1:
		two_way_dash_h = true
	elif dash_type == 2:
		two_way_dash_v = true
	elif dash_type == 3:
		two_way_dash_h = true
		two_way_dash_v = true
	elif dash_type == 4:
		eight_way_dash = true
	#endregion
	
func _physics_process(delta: float) -> void:
	_gravity()
	_horizontal_movement(delta)
	_handle_rolling()
	_handle_jumping()
	_handle_dashing()
	
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
		#print("reg jump" + str(player.movement_controller.jump_count))
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

func _handle_dashing():
	if player.DASH:
		if player.is_on_floor():
			dash_count = num_dashes
	
	if eight_way_dash and player.input_controller.action_right_press and dash_count > 0: #and !rolling
		#var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
		_dash("eight_way")
		#if (!player.input_controller.left_hold and !player.input_controller.right_hold and !player.input_controller.up_hold and !player.input_controller.down_hold):
			#player.velocity.x = dashMagnitude * h_direction
		#elif (!player.input_controller.right_hold and !player.input_controller.right_hold and !player.input_controller.right_hold and !player.input_controller.right_hold) and !was_moving_R:
			#player.velocity.x = -dashMagnitude
		
	if two_way_dash_v and player.input_controller.action_right_press and dash_count > 0:
		if player.input_controller.up_hold:
			_dash("v_two_way")
	
	if two_way_dash_h and player.input_controller.action_right_press and dash_count > 0:
		if h_direction != 0 and !(player.input_controller.up_hold or player.input_controller.down_hold):
			_dash("h_two_way")
			
	_dash_cancel()

func _dash(type_dash):
	var dash_time = 0.0625 * dash_length

	_dashing_time(dash_time)
	_pause_gravity(dash_time)
	
	match type_dash:
		"eight_way":
			var input_direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
			player.velocity = dashMagnitude * input_direction
		"v_two_way":
			player.velocity = Vector2(0 , -dashMagnitude)
		"h_two_way":
			player.velocity = Vector2(dashMagnitude * h_direction, 0)

	dash_count += -1
	movementInputMonitoring = Vector2(false, false)
	_input_pause_reset(dash_time)
	
func _dash_cancel():
	if dashing and player.velocity.x > 0 and player.input_controller.left_press and dash_cancel:
		player.velocity.x = 0 
	if dashing and player.velocity.x < 0 and player.input_controller.right_press and dash_cancel:
		player.velocity.x = 0 

func _corner_cutting():
	if corner_cutting:
		pass
		if player.velocity.y < 0 and L_raycast.is_colliding() and !R_raycast.is_colliding() and !M_raycast.is_colliding():
			player.position.x += corner_correction
		if player.velocity.y < 0 and !L_raycast.is_colliding() and R_raycast.is_colliding() and !M_raycast.is_colliding():
			player.position.x -= corner_correction

func _handle_rolling():
	if player.ROLL: 
		if player.is_on_floor() and player.input_controller.action_right_press:
			_rolling_time(roll_duration * 0.25)
			if !player.input_controller.up_hold:
				#print("roll")
				player.velocity = Vector2(max_speed_locked * roll_duration * h_direction, 0)
				dash_count += -1
				movementInputMonitoring = Vector2(false, false)
				_input_pause_reset(roll_duration * 0.0625)
				
	if player.ROLL and rolling:
		#functionality to have the player get i-frames
		#move this to Roll state
		pass

#region Timers
func _input_pause_reset(time):
	await get_tree().create_timer(time).timeout
	movementInputMonitoring = Vector2(true, true)

func _rolling_time(time):
	rolling = true
	await get_tree().create_timer(time).timeout
	rolling = false	

func _buffer_jump():
	await get_tree().create_timer(jump_buffer_time).timeout
	jump_was_pressed = false

func _coyote_time():
	await get_tree().create_timer(coyote_time).timeout
	coyote_active = false
	jump_count += -1

func _dashing_time(time):
	dashing = true
	await get_tree().create_timer(time).timeout
	dashing = false
	if !player.is_on_floor():
		player.velocity.y = -gravity_strength * 10
		
func _pause_gravity(time):
	gravity_active = false
	await get_tree().create_timer(time).timeout
	gravity_active = true

#endregion

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
