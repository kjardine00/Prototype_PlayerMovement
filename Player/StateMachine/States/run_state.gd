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
	player.handle_climb()
	handle_animation()
	handle_idle()
	
func handle_animation():	
	pass
	#player.anim.play("run")

func handle_idle():
	if player.move_direction_x == 0:
		state_machine.change_state(state_machine.IDLE)
