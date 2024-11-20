extends State

## RUN State

func enter_state():
	pass
	
func exit_state():
	pass
	
func update(delta: float):
	player.jumps_taken = 0
	
	player.h_movement()
	player.handle_jump()
	player.handle_falling()
	handle_animation()
	handle_idle()
	
func handle_animation():
	player.anim.play("run")
	player.handle_flip_h()

func handle_idle():
	if player.move_direction_x == 0:
		state_machine.change_state(state_machine.IDLE)
