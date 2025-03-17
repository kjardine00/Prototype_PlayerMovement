extends State

## WALKING State

func enter_state():
	pass
	
func exit_state():
	pass
	
func update(_delta: float):
	player.movement_handler.set_x_direction(state_machine.input_direction.x)
	transition_to_falling()

func transition_to_falling():
	if !player.is_on_floor():
		state_machine.change_state(state_machine.FALLING)
