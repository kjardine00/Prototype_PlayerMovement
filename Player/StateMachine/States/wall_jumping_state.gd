extends State

## WALL_JUMP State

func enter_state():
	player.movement_handler.wall_jump(state_machine.input_direction)
	
func exit_state():
	pass
	
func update(_delta: float):
	handle_animation("wall_jump")
	transition_logic()

func transition_logic():
	if player.is_on_wall():
		state_machine.change_state(state_machine.WALL_SLIDING)
		player.reset_num_jumps()
	if player.velocity.y >= 0:
		state_machine.change_state(state_machine.FALLING)

func handle_jump_released():
	player.movement_handler.cut_jump()
