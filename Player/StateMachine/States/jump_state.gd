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
	player.handle_flip_h()

func handle_jump_to_fall():
	if player.velocity.y >= 0: 
		state_machine.change_state(state_machine.FALL)
	elif not player.action_down:
		player.velocity.y *= player.JUMP_MULT
		state_machine.change_state(state_machine.FALL)
