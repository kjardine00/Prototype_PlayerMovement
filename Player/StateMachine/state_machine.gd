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
@export var DASHING : State
#@export var CLIMB : State

var current_state: State
var prev_state: State

var input_direction : Vector2

@onready var state_label: Label = $"../CurrentState"

func _ready() -> void:
	for state in self.get_children():
		if state is State:
			state.player = player_character
			state.state_machine = self
			
	current_state = IDLING
	prev_state = IDLING
	state_label.text = str(current_state)
	
func change_state(next_state):
	if next_state:
		#print("From: " + prev_state.name + " To: " + current_state.name)
		prev_state = current_state
		current_state = next_state
		prev_state.exit_state()
		current_state.enter_state()
		state_label.text = str(current_state)

func handle_movement_input(direction):
	current_state.handle_movement_input(direction)

#region Jump Buffer
var jump_is_buffering := false

func _jump_buffer_timer(time):
	await get_tree().create_timer(time).timeout
	jump_is_buffering = false
#endregion

func handle_jump_input():
	if current_state != JUMPING or current_state != FALLING or current_state != WALL_JUMPING:
		if player_character.is_on_floor():
			current_state.handle_jump_input()
		elif current_state == WALL_SLIDING:
			current_state.handle_jump_input()
		else:
			jump_is_buffering = true
			_jump_buffer_timer(0.2)
		if jump_is_buffering and player_character.is_on_floor():
			current_state.handle_jump_input()
	else: #player is in an in the air state and is handling any double jump effects
		if player_character.num_of_available_jumps > 0:
			current_state.handle_jump_input()
		elif player_character.num_of_available_jumps == 0:
			print_debug("player has no more jumps")
			pass

func handle_jump_released():
	if current_state == JUMPING or current_state == FALLING:
		current_state.handle_jump_released()

func handle_ability_input():
	current_state.handle_ability_input(player_character.body_ability)
