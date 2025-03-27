extends State

## IDLE State

func enter_state():
	player.movement_handler.set_x_direction(0)
	player.reset_num_jumps()
