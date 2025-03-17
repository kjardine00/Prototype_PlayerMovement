extends State

## JUMP State

func enter_state():
	player.movement_handler.jump()
	
func exit_state():
	pass
	
func update(_delta: float):
	transisition_logic()
	handle_animation("jump")
	player.movement_handler.set_x_direction(state_machine.input_direction.x)

func transisition_logic():
	if player.velocity.y >= 0:
		player.state_machine.change_state(state_machine.FALLING)

func handle_movement_input(direction):
	super(direction)
	
	if direction.y > 0:
		player.movement_handler.fast_fall()
		state_machine.change_state(state_machine.FALLING)

func handle_jump_input():
	player.movement_handler.jump()

func tranistion_to_wall_slide():
	if player.is_on_wall() && state_machine.input_direction.x != 0:
		state_machine.change_state(state_machine.WALL_SLIDING)

func handle_jump_released():
	player.movement_handler.cut_jump()
