extends State

## JUMP State

func enter_state():
	player.movement_handler.jump()
	
func exit_state():
	pass
	
func update(delta: float):
	super(delta)
	handle_wall_slide_tranisition()
	transisition_to_fall_state()
	handle_animation("jump")

func transisition_to_fall_state():
	if player.velocity.y >= 0:
		player.state_machine.change_state(state_machine.FALLING)

func handle_movement_input(direction):
	super(direction)
	if direction.y > 0:
		player.movement_handler.fast_fall()
		state_machine.change_state(state_machine.FALLING)

func handle_jump_input():
	player.movement_handler.jump()

func handle_jump_released():
	player.movement_handler.cut_jump()
