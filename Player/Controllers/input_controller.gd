extends Node2D
class_name Input_Controller

signal direction

@export var player : Player

#region Input Variables
var h_move_axis

# Joystick / WASD
var up_hold = false
var up_press = false
var down_press = false
var down_hold = false
var left_hold = false
var left_press = false
var right_hold = false
var right_press = false

# Right Action Buttons, 
var action_up_hold = false
var action_up_press = false
var action_down_hold = false
var action_down_press = false
var action_down_release = false
var action_left_hold = false
var action_left_press = false
var action_right_hold = false
var action_right_press = false

# Admin Buttons
var esc_press = false
var menu_press = false

# D-pad Buttons
var d_up_hold = false
var d_up_press = false
var d_down_hold = false
var d_down_press = false
var d_left_hold = false
var d_left_press = false
var d_right_hold = false
var d_right_press = false

# Bumper Buttons
var r1_hold = false
var r1_press = false
var r2_hold = false
var r2_press = false
var l1_hold = false
var l1_press = false
var l2_hold = false
var l2_press = false

# Right Joystick
## TODO

# Memory of last directional input
var last_input_direction = Vector2.ZERO

#endregion

func _ready() -> void:
	handle_input()
	direction.emit(Vector2.RIGHT)

func _physics_process(_delta: float) -> void:
	if left_press: direction.emit(Vector2.LEFT)
	elif right_press: direction.emit(Vector2.RIGHT)
	
	handle_input()
	actions_update()
	handle_last_direction_pressed()

func handle_input():
	h_move_axis = Input.get_axis("move_left", "move_right")
	## LEFT Joystick, WASD
	up_hold = Input.is_action_pressed("move_up")
	up_press = Input.is_action_just_pressed("move_up")
	down_press = Input.is_action_just_pressed("move_down")
	down_hold = Input.is_action_pressed("move_down")
	left_hold = Input.is_action_pressed("move_left")
	left_press = Input.is_action_just_pressed("move_left")
	right_hold = Input.is_action_pressed("move_right")
	right_press = Input.is_action_just_pressed("move_right")
	
	# Right Action Buttons, 
	action_up_hold = Input.is_action_pressed("action_up")
	action_up_press = Input.is_action_just_pressed("action_up")
	action_down_hold = Input.is_action_pressed("action_down")
	action_down_press = Input.is_action_just_pressed("action_down")
	action_down_release = Input.is_action_just_released("action_down")
	action_left_hold = Input.is_action_pressed("action_left")
	action_left_press = Input.is_action_just_pressed("action_left")
	action_right_hold = Input.is_action_pressed("action_right")
	action_right_press = Input.is_action_just_pressed("action_right")

	# Bumper Buttons
	r1_hold = Input.is_action_pressed("r1")
	r1_press = Input.is_action_just_pressed("r1")
	r2_hold = Input.is_action_pressed("r2")
	r2_press = Input.is_action_just_pressed("r2")
	l1_hold = Input.is_action_pressed("l1")
	l1_press = Input.is_action_just_pressed("l1")
	l2_hold = Input.is_action_pressed("l2")
	l2_press = Input.is_action_just_pressed("l2")
	
func handle_last_direction_pressed():
	if up_hold:
		last_input_direction = Vector2.UP
	elif down_hold:
		last_input_direction = Vector2.DOWN
	elif left_hold:
		last_input_direction = Vector2.LEFT
	elif right_hold:
		last_input_direction = Vector2.RIGHT
	else:
		last_input_direction = Vector2.ZERO

func actions_update():
	##Triangle, X, Y, F
	if action_up_press:
		#print("ACTION UP")
		player.handle_interact_action()
		
	## X, B, A, SPACE
	if action_down_press:
		#print("ACTION DOWN")
		pass
		
	##Circle, A, B, RMB
	if action_right_press:
		## Use utility equip ability
		#print("ACTION RIGHT")
		pass
	
	##Square, Y, X, LMB
	if action_left_press:
		##Attack with active item
		#print("ACTION LEFT")
		player.inv_controller.handle_attack_input(last_input_direction)
	
	if r1_press:
		##throw held item
		#print("ACTION R1")
		player.inv_controller.swap_active()
	
	if r2_press:
		#print("ACTION R2")
		pass
		
	if l1_press:
		##Swap active and non active item
		#print("ACTION L1")
		player.inv_controller.handle_throw_drop(last_input_direction)
		
	if l2_press:
		#print("ACTION L2")
		pass
