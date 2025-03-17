extends Node2D
class_name MovementHandler

@export var player : Player

##NOTE: This direction is more dynamic that just the H values, it also is getting the Y values
var direction := Vector2.ZERO

#region Movement Variables
@export var move_speed := 200
#endregion

#region Jumping and Gravity 
@export var jump_height : float = 3
@export var jump_time_to_peak : float = 0.5
@export var jump_time_to_descent : float = 0.4
@export var tile_size : int = 128

@onready var jump_velocity : float = ((2.0 * (jump_height * tile_size)) / jump_time_to_peak) * -1.0
@onready var jump_gravity : float = ((-2.0 * (jump_height * tile_size)) / (jump_time_to_peak * jump_time_to_peak)) * -1.0
@onready var fall_gravity : float = ((-2.0 * (jump_height * tile_size)) / (jump_time_to_descent * jump_time_to_descent)) * -1.0
@onready var cut_jump_factor: float = 0.5
@onready var fast_fall_factor: float = cut_jump_factor * 1.5
@onready var wall_slide_gravity : float = fall_gravity * 0.33
#endregion

func _physics_process(delta: float) -> void:
	player.velocity.y += get_gravity() * delta
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
	return fall_gravity

## Call this function to set the direction of movement to the player, if ZERO the player will not move
func set_x_direction(x_direction : float):
	direction.x = x_direction

## pass a value if you want to modify the jump amount from default
func jump(double_jump_modifier: float = 1):
	if player.num_of_available_jumps > 0:
		player.velocity.y = jump_velocity * double_jump_modifier
		player.num_of_available_jumps -= 1
	else:
		pass

func cut_jump():
	player.velocity.y *= cut_jump_factor

func fast_fall():
	player.velocity.y *= fast_fall_factor

func wall_jump(
	h_direction : Vector2,
	wall_kick_angle : float = 45,
	input_pause : float = 0.1,
):
	var h_wall_kick = abs(jump_height * cos(wall_kick_angle * (PI / 180)))
	var y_wall_kick = abs(jump_height * sin(wall_kick_angle * (PI / 180)))
	
	player.velocity.y = -y_wall_kick
	player.velocity.x = -h_wall_kick * -h_direction
	
	if input_pause != 0:
		_input_pause_reset(input_pause)

func dash():
	print_debug("Dash")
	

#region ============================= Timers =============================
func _input_pause_reset(time):
	await get_tree().create_timer(time).timeout
	
func _buffer_jump(time):
	await get_tree().create_timer(time).timeout
	#jump_was_pressed = false

func _coyote_time(time):
	await get_tree().create_timer(time).timeout
	#coyote_active = false
	player.num_of_available_jumps += -1
#endregion
