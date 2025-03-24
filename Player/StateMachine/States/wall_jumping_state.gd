extends State

## WALL_JUMP State

func enter_state():
	#print("Entering WALL_JUMP, velocity: ", player.velocity)
	player.movement_handler.wall_jump()
	#print("Entering WALL_JUMP, velocity after jump: ", player.velocity)
	
func exit_state():
	pass
	
func update(delta: float):
	super(delta)
	handle_animation("wall_jump")
	transisition_to_fall_state()
	handle_wall_slide_tranisition()

func handle_jump_released():
	player.movement_handler.cut_jump()

func transisition_to_fall_state():
	if player.velocity.y > 0:
		player.state_machine.change_state(state_machine.FALLING)
