extends State

## WALKING State

func enter_state():
	player.reset_num_jumps()
	player.anim_controller.transition_animation(state_machine.prev_state, self)