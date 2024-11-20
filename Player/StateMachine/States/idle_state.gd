extends State

## IDLE State

func enter_state():
	pass
	
func exit_state():
	pass
	
func update(delta: float):
	player.handle_falling()
	player.handle_jump()
	player.h_movement()
	handle_run()
	handle_animation()
	
func handle_animation():
	player.anim.play("idle")
	#player.handle_flip_h()

func handle_run():
	if player.move_direction_x != 0:
		state_machine.change_state(state_machine.RUN)
