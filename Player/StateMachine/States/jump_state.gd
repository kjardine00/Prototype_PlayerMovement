extends State

## JUMP State

func enter_state():
	player.movement_controller.jump()
	
func exit_state():
	pass
	
func update(delta: float):
	player.movement_controller.handle_gravity(delta)
	player.movement_controller.h_movement(delta)
	player.movement_controller.handle_jump()
	player.movement_controller.handle_wall_jump()
	player.movement_controller.handle_wall_slide()
	handle_jump_to_fall()
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
