extends State

## JUMP State

func enter_state():
	player.velocity.y += player.JUMP_VELOCITY
	
	
func exit_state():
	pass
	
func update(delta: float):
	player.handle_gravity(delta)
	player.h_movement()
	player.handle_jump()
	player.handle_wall_jump()
	player.handle_wall_slide()
	handle_jump_to_fall()
	handle_animation()
	
func handle_animation():
	player.anim.play("jump")

func handle_jump_to_fall():
	if player.velocity.y >= 0:
		if (player.wall_direction != Vector2.ZERO) and (player.move_left or player.move_right):
			state_machine.change_state(state_machine.FALL)
		else:
			state_machine.change_state(state_machine.WALL_SLIDE)
	elif not player.action_down:
		player.velocity.y *= player.JUMP_MULT
		state_machine.change_state(state_machine.FALL)
