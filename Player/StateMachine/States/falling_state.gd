extends State

## FALL State

func enter_state():
	pass
	
func exit_state():
	pass
	
func update(_delta: float):
	handle_animation("fall")
	handle_landing()
	player.movement_handler.set_x_direction(state_machine.input_direction.x)

func handle_movement_input(direction):
	super(direction)
	
	if direction.y > 0:
		player.movement_handler.fast_fall()

func handle_landing():
	if player.is_on_floor():
		if player.movement_handler.direction.x != 0:
			state_machine.change_state(state_machine.WALKING)
			player.reset_num_jumps()
		else:
			state_machine.change_state(state_machine.IDLING)
			player.reset_num_jumps()
	elif player.is_on_wall_only():
		state_machine.change_state(state_machine.WALL_SLIDING)
		player.reset_num_jumps()

func handle_jump_released():
	player.movement_handler.cut_jump()
