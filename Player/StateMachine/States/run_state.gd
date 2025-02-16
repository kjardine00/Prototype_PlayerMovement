extends State

## RUN State

func enter_state():
	pass
	
func exit_state():
	pass
	
func update(_delta: float):
	handle_animation("run")

func handle_idle():
	if player.input_controller.h_move_axis == 0:
		state_machine.change_state(state_machine.IDLE)
