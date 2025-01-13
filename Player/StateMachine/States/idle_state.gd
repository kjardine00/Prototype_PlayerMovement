extends State

## IDLE State

func enter_state():
	pass
	
func exit_state():
	pass
	
func update(delta: float):
	player.movement_controller.handle_falling()
	player.movement_controller.handle_jump()
	player.movement_controller.h_movement(delta)
	player.movement_controller.handle_climb()
	handle_run()
	handle_animation("idle")

func handle_run():
	if player.input_controller.h_move_axis != 0:
		state_machine.change_state(state_machine.RUN)
