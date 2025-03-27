func wall_jump():
	if player.num_of_available_jumps > 0:
		player.num_of_available_jumps -= 1

	var wall_normal = player.get_wall_normal()
	input_pause = true  # This is preventing movement
	
	if wall_normal.x != 0:
		player.velocity = Vector2(
			wall_jump_push_velocity * wall_normal.x,
			wall_jump_height_velocity
		)
	
	# Add a shorter input pause timer
	_input_pause_reset(0.1)  # Reduced from 0.2 to 0.1 seconds 
