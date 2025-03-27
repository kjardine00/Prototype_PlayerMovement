extends State

## WALL_SLIDE State

func enter_state():
	player.reset_num_jumps()
	player.velocity.y = 0
