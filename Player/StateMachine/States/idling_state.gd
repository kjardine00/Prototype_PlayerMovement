extends State

## IDLE State

func enter_state():
	player.movement_handler.set_x_direction(0)
	
func exit_state():
	pass
	
func update(_delta: float):
	pass

func handle_movement_input(direction):
	state_machine.input_direction = direction
	if direction != Vector2.ZERO:
		state_machine.change_state(state_machine.WALKING)

func handle_jump_input():
	state_machine.change_state(state_machine.JUMPING)
