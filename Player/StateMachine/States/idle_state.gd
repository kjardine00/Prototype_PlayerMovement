extends State

## IDLE State

func enter_state():
	pass
	
func exit_state():
	pass
	
func update(_delta: float):
	handle_animation("idle")

func handle_run():
	if player.input_controller.h_move_axis != 0:
		state_machine.change_state(state_machine.RUN)
