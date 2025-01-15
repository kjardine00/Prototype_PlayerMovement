extends State

## JUMP State

func enter_state():
	pass
	
func exit_state():
	pass
	
func update(delta: float):
	handle_animation("jump")


func handle_jump_to_fall():
	if player.velocity.y >= 0:
		if (player.wall_direction != Vector2.ZERO) and (player.input_controller.left_hold or player.input_controller.right_hold):
			player.state_machine.change_state(player.state_machine.FALL)
		else:
			player.state_machine.change_state(player.state_machine.WALL_SLIDE)
	elif not player.input_controller.action_down_hold:
		#TODO figure what this did and make it do what it was doing
		#player.velocity.y *= player.movement_controller
		player.state_machine.change_state(player.state_machine.FALL)
