extends Node
class_name State

var state_machine: State_Machine
var player : Player 

func enter_state():
	pass
	
func exit_state():
	pass
	
func update(_delta: float):
	pass
	
func handle_animation(anim_name : String):
	pass
	#state_machine.player_character.anim_controller.play_anim(anim_name)

func handle_movement_input(direction):
	state_machine.input_direction = direction
	if state_machine.input_direction.x == 0 && player.is_on_floor():
		state_machine.change_state(state_machine.IDLING)

func handle_jump_input():
	if state_machine.current_state == state_machine.WALL_SLIDING:
		state_machine.change_state(state_machine.WALL_JUMPING)
	elif state_machine.current_state != state_machine.JUMPING:
		state_machine.change_state(state_machine.JUMPING)
