extends Node
class_name State_Machine

@export var player_character: Player

@export_category("Connect States")
@export var IDLING : State
@export var WALKING : State
@export var JUMPING : State
@export var FALLING : State
@export var WALL_JUMPING : State
@export var WALL_SLIDING : State
@export var ROLLING : State

@export var DASHING : State
#@export var CLIMB : State

var current_state: State
var prev_state: State

var input_direction : Vector2
var input_jump: bool

@onready var state_label: Label = $"../CurrentState"

@export_category("Jump Buffer Settings")
@export var jump_buffer_time: float = 0.1  # Time window for jump buffer in seconds
@export var wall_jump_buffer_time: float = 0.1  # Time window for wall jump buffer in seconds

var jump_buffer_timer: float = 0.0
var jump_is_buffered: bool = false
var wall_jump_buffer_timer: float = 0.0
var wall_jump_is_buffered: bool = false

#region Core State Machine
func _ready() -> void:
	for state in self.get_children():
		if state is State:
			state.player = player_character
			state.state_machine = self
			
	current_state = IDLING
	prev_state = IDLING
	state_label.text = str(current_state)

func _physics_process(_delta: float):
	check_state_transitions()
	
	# Update jump buffer timers
	if jump_is_buffered:
		jump_buffer_timer -= _delta
		if jump_buffer_timer <= 0:
			jump_is_buffered = false
			
	if wall_jump_is_buffered:
		wall_jump_buffer_timer -= _delta
		if wall_jump_buffer_timer <= 0:
			wall_jump_is_buffered = false

func change_state(next_state):
	if next_state:
		print("From: " + prev_state.name + " To: " + current_state.name)
		prev_state = current_state
		current_state = next_state
		prev_state.exit_state()
		current_state.enter_state()
		state_label.text = str(current_state)
#endregion

#region State Transitions
func check_state_transitions():
	match current_state:
		IDLING:
			# Priority: Falling > Walking
			if !player_character.is_on_floor():
				change_state(FALLING)
			elif input_direction != Vector2.ZERO:
				change_state(WALKING)
		
		WALKING:
			# Priority: Falling > Idle
			if !player_character.is_on_floor():
				change_state(FALLING)
			elif input_direction == Vector2.ZERO:
				change_state(IDLING)
				
		FALLING:
			# Priority: Floor Landing > Wall Slide
			if player_character.is_on_floor():
				if jump_is_buffered:
					change_state(JUMPING)
				elif input_direction == Vector2.ZERO:
					change_state(IDLING)
				else:
					change_state(WALKING)
			elif player_character.is_on_wall() && player_character.wall_detector.is_colliding():
				change_state(WALL_SLIDING)
			elif jump_is_buffered && player_character.movement_handler.coyote_active:
				change_state(JUMPING)

		JUMPING:
			# Priority: Wall Slide > Floor Landing > Falling
			if player_character.is_on_wall() && player_character.wall_detector.is_colliding():
				change_state(WALL_SLIDING)
			elif player_character.is_on_floor():
				if input_direction == Vector2.ZERO:
					change_state(IDLING)
				else:
					change_state(WALKING)
			elif player_character.velocity.y >= 0:  # At peak of jump or moving down
				change_state(FALLING)

		WALL_SLIDING:
			# Priority: Floor Landing > Wall Jump > Lost Wall Contact
			if player_character.is_on_floor():
				if input_direction == Vector2.ZERO:
					change_state(IDLING)
				else:
					change_state(WALKING)
			elif input_jump or wall_jump_is_buffered:  # Modified to check for buffered wall jump
				change_state(WALL_JUMPING)
			elif !player_character.is_on_wall() || !player_character.wall_detector.is_colliding():
				change_state(FALLING)

		WALL_JUMPING:
			# Priority: Wall Slide > Floor Landing > Falling
			if player_character.is_on_wall() && player_character.wall_detector.is_colliding():
				change_state(WALL_SLIDING)
			elif player_character.is_on_floor():
				if input_direction == Vector2.ZERO:
					change_state(IDLING)
				else:
					change_state(WALKING)
			elif player_character.velocity.y >= 0:  # At peak of wall jump or moving down
				change_state(FALLING)

		ROLLING:
			# Priority: Floor Landing > Wall Slide > Falling | Jumping is handled in state.gd
			if player_character.is_on_floor():
				if input_direction == Vector2.ZERO:
					change_state(IDLING)
				else:
					change_state(WALKING)
			elif player_character.is_on_wall() && player_character.wall_detector.is_colliding():
				change_state(WALL_SLIDING)
			elif player_character.velocity.y >= 0:
				change_state(FALLING)

		# DASHING:
			## To Falling, Idle, Walking, Wall Sliding, Jumping, Dashing
			
func handle_movement_input(direction):
	input_direction = direction
	current_state.handle_movement_input(input_direction)
		
func handle_jump_input():
	input_jump = true
	jump_is_buffered = true
	jump_buffer_timer = jump_buffer_time
	wall_jump_is_buffered = true
	wall_jump_buffer_timer = wall_jump_buffer_time
	current_state.handle_jump_input()
	await get_tree().physics_frame
	input_jump = false

func handle_jump_released():
	match current_state:
		JUMPING:
			# Cut the jump short when button is released during upward motion
			if player_character.velocity.y < 0:  # Moving upward
				player_character.movement_handler.cut_jump()
		WALL_JUMPING:
			# Same for wall jumps
			if player_character.velocity.y < 0:
				player_character.movement_handler.cut_jump()

func handle_ability_input(ability_type : BodyEquip.AbilityType):
	match ability_type:
		BodyEquip.AbilityType.DASH:
			change_state(DASHING)
#endregion
