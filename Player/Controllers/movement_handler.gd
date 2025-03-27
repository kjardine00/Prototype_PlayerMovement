extends Node2D
class_name MovementHandler

@export_category("Connections")
@export var player : Player
@export var L_raycast : RayCast2D
@export var M_raycast : RayCast2D
@export var R_raycast : RayCast2D

##NOTE: This direction is more dynamic that just the H values, it also is getting the Y values
var direction := Vector2.ZERO

@export_category("General Properties")
@export var move_speed := 200
@export var max_fall_speed := 10
@export var tile_size : int = 128

#region Jumping and Gravity
@export_category("Jumping and Gravity")
@export_group("Jump")
##How many tiles HIGH can the character jump
@export var jump_height : float = 3
@export var jump_time_to_peak : float = 0.5
@export var jump_time_to_descent : float = 0.4
@export var coyote_time : float = 0.2
@export_group("Wall Jump")
##How many tiles LONG can the character WALL jump
@export var wall_jump_height : float = 1.5
@export var wall_jump_push_distance : float = 1.5
@export var wall_jump_time_to_peak : float = 0.5
@export var wall_jump_time_to_descent : float = 0.4

@export_group("Gravity Variables")
@export var wall_slide_gravity_multiplier : float = 0.33
#endregion

#region Gravity and Jump Calculations
@onready var jump_velocity : float = ((2.0 * (jump_height * tile_size)) / jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((-2.0 * (jump_height * tile_size)) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity : float = ((-2.0 * (jump_height * tile_size)) / (jump_time_to_descent * jump_time_to_descent)) * -1.0
@onready var cut_jump_factor: float = 0.5
@onready var fast_fall_factor: float = cut_jump_factor * 1.5
@onready var wall_slide_gravity : float = fall_gravity * wall_slide_gravity_multiplier

@onready var wall_jump_push_velociy : float = ((2.0 * (wall_jump_push_distance * tile_size)) / wall_jump_time_to_peak)
@onready var wall_jump_height_velocity: float = ((2.0 * (wall_jump_height * tile_size)) / wall_jump_time_to_peak) * -1.0
@onready var terminal_fall_velocity := max_fall_speed * tile_size  
#endregion

var coyote_timer : float = 0.0
var coyote_active : bool = false

#region Dash / Ability Settings
@export_category("Dashing and other abilities")
@export var dash_length: float = 4 #Number of tiles the player will dash
@export var dash_duration: float = 0.5 # seconds to reach the distance of the dash
@onready var dash_velocity: float = (dash_length * tile_size) / dash_duration #px/s * direction
#endregion

func _physics_process(delta: float) -> void:
	player.velocity.y += get_gravity() * delta
	
	# Clamp fall speed
	if player.velocity.y > terminal_fall_velocity:
		player.velocity.y = terminal_fall_velocity
	
	# Update coyote time
	if player.is_on_floor():
		coyote_active = true
		coyote_timer = coyote_time
	elif coyote_active:
		coyote_timer -= delta
		if coyote_timer <= 0:
			coyote_active = false
	
	player.velocity.x = direction.x * move_speed
	player.move_and_slide()
	
func get_gravity() -> float:
	match player.state_machine.current_state:
		player.state_machine.FALLING:
			return fall_gravity
		player.state_machine.JUMPING:
			return jump_gravity
		player.state_machine.WALL_JUMPING:
			return jump_gravity
		player.state_machine.WALL_SLIDING:
			return wall_slide_gravity
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
		coyote_active = false  # Reset coyote time when jumping

func cut_jump():
	player.velocity.y *= cut_jump_factor

func fast_fall():
	player.velocity.y *= fast_fall_factor

func wall_jump():
	if player.num_of_available_jumps > 0:
		player.num_of_available_jumps -= 1

	var wall_normal = player.get_wall_normal()
	
	if wall_normal.x != 0:
		var current_direction = direction.x
		# Set both velocity and direction for initial push
		player.velocity = Vector2(
			wall_jump_push_velociy * wall_normal.x , 
			wall_jump_height_velocity
		)
		direction = Vector2(wall_normal.x, 0)
		# Reset direction after a short delay to allow player control
		await get_tree().create_timer(0.1).timeout
		direction.x = current_direction

func dash():
	print_debug("Dash")
	#player.velocity.x = dash_velocity
	
func v_corner_cutting(cutting_enabled: bool = true, correction_amount : float = 1.5):
	if cutting_enabled:
		if player.velocity.y < 0 and L_raycast.is_colliding() and !R_raycast.is_colliding() and !M_raycast.is_colliding():
			player.position.x += correction_amount
		if player.velocity.y < 0 and !L_raycast.is_colliding() and R_raycast.is_colliding() and !M_raycast.is_colliding():
			player.position.x -= correction_amount
