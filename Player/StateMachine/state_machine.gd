extends Node
class_name State_Machine

@export var player_character: Player

@export_category("Connect States")
@export var IDLE : State
@export var RUN : State
@export var JUMP : State
@export var FALL : State
@export var WALL_JUMP : State
@export var WALL_SLIDE : State

var current_state: State
var prev_state: State

func _ready() -> void:
	for state in self.get_children():
		if state is State:
			state.player = player_character
			state.state_machine = self
			
	current_state = FALL
	prev_state = FALL

func change_state(next_state):
	if next_state:
		prev_state = current_state
		current_state = next_state
		prev_state.exit_state()
		current_state.enter_state()
		print("From: " + prev_state.name + " To: " + current_state.name)
