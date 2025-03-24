extends Node2D
class_name MovementHandler

@export_category("Connections")
@export var player : Player
@export var L_raycast : RayCast2D
@export var M_raycast : RayCast2D
@export var R_raycast : RayCast2D

##NOTE: This direction is more dynamic that just the H values, it also is getting the Y values
var direction := Vector2.ZERO
var input_pause : bool 

@export_category("Properties")
@export var move_speed := 200

#region Jumping and Gravity
@export var tile_size : int = 128
@export_group("Jump")
##How many tiles HIGH can the character jump
@export var jump_height : float = 3
@export var jump_time_to_peak : float = 0.5
@export var jump_time_to_descent : float = 0.4
@export_group("Wall Jump")
##How many tiles LONG can the character WALL jump
@export var wall_jump_push_distance : float = 1.5
##How many tiles HIGH can the character WALL jump
@export var wall_jump_height : float = 2.5
@export var wall_jump_time_to_peak : float = 0.5
@export var wall_jump_time_to_descent : float = 0.4

@onready var jump_velocity : float = ((2.0 * (jump_height * tile_size)) / jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((-2.0 * (jump_height * tile_size)) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity : float = ((-2.0 * (jump_height * tile_size)) / (jump_time_to_descent * jump_time_to_descent)) * -1.0
@onready var cut_jump_factor: float = 0.5
@onready var fast_fall_factor: float = cut_jump_factor * 1.5
@onready var wall_slide_gravity : float = fall_gravity * 0.5
@onready var wall_jump_push_velociy : float = ((2.0 * (wall_jump_push_distance * tile_size)) / wall_jump_time_to_peak)
@onready var wall_jump_height_velocity: float = ((2.0 * (wall_jump_height * tile_size)) / wall_jump_time_to_peak) * -1.0
#endregion

#region Dash / Ability Settings
@export_category("Dashing and other abilities")
@export var dash_length: float = 4 #Number of tiles the player will dash
@export var dash_duration: float = 0.5 # seconds to reach the distance of the dash
@onready var dash_velocity: float = (dash_length * tile_size) / dash_duration #px/s * direction
#endregion

func _physics_process(delta: float) -> void:
	player.velocity.y += get_gravity() * delta
	if input_pause == true:
		_input_pause_reset(0.2)
		direction = Vector2.ZERO
	else:
		player.velocity.x = direction.x * move_speed
	player.move_and_slide()
	
func get_gravity() -> float:
	match player.state_machine.current_state:
		player.state_machine.FALLING:
			return fall_gravity
		player.state_machine.JUMPING:
			return jump_gravity
		player.state_machine.WALL_SLIDING:
			return wall_slide_gravity
		player.state_machine.WALL_JUMPING:
			return jump_gravity
		player.state_machine.DASHING:
			return 0
	return fall_gravity

## Call this function to set the direction of movement to the player, if ZERO the player will not move
func set_x_direction(x_direction : float):
	direction.x = x_direction

## pass a value if you want to modify the jump amount from default
func jump(double_jump_modifier: float = 1):
	if player.num_of_available_jumps > 0: #This line is redundant since state_machine checks this value before calling this function
		player.velocity.y = jump_velocity * double_jump_modifier
		player.num_of_available_jumps -= 1

func cut_jump():
	player.velocity.y *= cut_jump_factor

func fast_fall():
	player.velocity.y *= fast_fall_factor

func wall_jump():
	var wall_normal = player.get_wall_normal()
	input_pause = true
	
	if wall_normal.x != 0:
		player.velocity = Vector2(wall_jump_push_velociy * wall_normal.x, wall_jump_height_velocity)
	print_debug(wall_normal, " ... ", player.velocity)

func dash():
	print_debug("Dash")
	player.velocity.x = dash_velocity
	
func v_corner_cutting(cutting_enabled: bool = true, correction_amount : float = 1.5):
	if cutting_enabled:
		if player.velocity.y < 0 and L_raycast.is_colliding() and !R_raycast.is_colliding() and !M_raycast.is_colliding():
			player.position.x += correction_amount
		if player.velocity.y < 0 and !L_raycast.is_colliding() and R_raycast.is_colliding() and !M_raycast.is_colliding():
			player.position.x -= correction_amount

#region ============================= Timers =============================
func _input_pause_reset(time):
	await get_tree().create_timer(time).timeout
	input_pause = false
	
func _buffer_jump(time):
	await get_tree().create_timer(time).timeout
	#jump_was_pressed = false
#endregion
