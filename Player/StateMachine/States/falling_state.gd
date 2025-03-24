extends State

## FALL State

func enter_state():
	#print("Entering FallingState, velocity: ", player.velocity)
	pass

func exit_state():
	pass
	
func update(delta: float):
	super(delta)
	handle_wall_slide_tranisition()
	handle_landing()
	handle_animation("fall")
	
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

func handle_jump_released():
	player.movement_handler.cut_jump()
