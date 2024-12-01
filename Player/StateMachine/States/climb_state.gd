extends State
## Climb State

var move_direction_y


func enter_state():
	pass
	
func exit_state():
	player.velocity.y = 0
	
func update(delta: float):
	handle_climb_movement()
	player.h_movement(player.CLIMB_ACCEL, player.CLIMB_DECEL)
	player.handle_stop_climbing()
	player.handle_jump()
	#player.handle_landing()
	handle_animation()
	
func handle_animation():
	if player.velocity.y > 0:
		player.anim.speed_scale = -1
	else:
		player.anim.speed_scale = 1
	#player.anim.play("climb")
	pass

func handle_climb_movement():
	if player.CAN_CLIMB:
		if !player.action_down:
			move_direction_y = Input.get_axis("move_up", "move_down")
			if move_direction_y:
				player.velocity.y = move_toward(player.velocity.y, move_direction_y * player.CLIMB_SPEED, player.CLIMB_ACCEL)
			else: 
				player.velocity.y = move_toward(player.velocity.y, move_direction_y * player.CLIMB_SPEED, player.CLIMB_DECEL)
		else:
			state_machine.change_state(state_machine.JUMP)
	else:
		state_machine.change_state(state_machine.FALL)
