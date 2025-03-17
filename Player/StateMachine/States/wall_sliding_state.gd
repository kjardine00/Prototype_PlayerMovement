extends State

## WALL_SLIDE State

func enter_state():
	pass
	
func exit_state():
	pass
	
func update(_delta: float):
	handle_animation("wall_slide")

func handle_jump_input():
	player.movement_handler.wall_jump(state_machine.input_direction)

func _handle_wall_slide_tranisition(delta):
	##If the player is no longer in contact with the wall -> fall state
	if state_machine.input_direction == Vector2.ZERO:
		player.state_machine.change_state(player.state_machine.FALL)
	
## check if the player is in contact with either wall side and holding the coresponding direction otherwise -> fall state
	if player.is_on_wall():
		if (state_machine.input_direction == Vector2.LEFT):
			state_machine.change_state(state_machine.WALL_SLIDING)
		elif (state_machine.input_direction == Vector2.RIGHT):
			state_machine.change_state(state_machine.WALL_SLIDING)
	else:
		state_machine.change_state(state_machine.FALL)
