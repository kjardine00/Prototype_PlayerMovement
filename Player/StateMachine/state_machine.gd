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
#@export var CLIMB : State

var current_state: State
var prev_state: State

var input_direction : Vector2

func _ready() -> void:
	for state in self.get_children():
		if state is State:
			state.player = player_character
			state.state_machine = self
			
	current_state = IDLING
	prev_state = IDLING

func change_state(next_state):
	if next_state:
		prev_state = current_state
		current_state = next_state
		prev_state.exit_state()
		current_state.enter_state()
		#print("From: " + prev_state.name + " To: " + current_state.name)

func handle_movement_input(direction):
	current_state.handle_movement_input(direction)

func handle_jump_input():
	if current_state != JUMPING or current_state != FALLING or current_state != WALL_JUMPING:
		current_state.handle_jump_input()
	else: #player is in a jump state and is handling any double jump effects
		if player_character.num_of_available_jumps > 0:
			current_state.handle_jump_input()
		elif player_character.num_of_available_jumps == 0:
			print_debug("player has no more jumps")
			pass

func handle_jump_released():
	if current_state == JUMPING or current_state == FALLING or current_state == WALL_JUMPING:
		current_state.handle_jump_released()
	
