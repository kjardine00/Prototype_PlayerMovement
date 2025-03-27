extends State

## DASHING State

var dash_finished: bool = false

func enter_state():
	state_machine.player_character.movement_handler.dash()