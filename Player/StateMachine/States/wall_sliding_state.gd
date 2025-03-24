extends State

## WALL_SLIDE State

func enter_state():
	player.reset_num_jumps()
	
func exit_state():
	pass
	
func update(delta: float):
	super(delta)
	handle_animation("wall_slide")
	handle_fall_transition()

func handle_jump_input():
	state_machine.change_state(state_machine.WALL_JUMPING)

func handle_fall_transition():
	##If the player is no longer in contact with the wall -> fall state
	if state_machine.input_direction == Vector2.ZERO or !player.wall_detector.is_colliding():
		player.state_machine.change_state(player.state_machine.FALLING)
