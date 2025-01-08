extends State

## WALL_JUMP State

var last_wall_direction
var should_enable_walk_kick

func enter_state():
	player.velocity.y = player.WALL_JUMP_VELOCITY
	last_wall_direction = player.wall_direction
	should_only_jump_button_wall_kick(false)
	
func exit_state():
	pass
	
func update(delta: float):
	player.get_wall_direction()
	player.handle_gravity(delta, player.GRAVITY_JUMP)
	handle_wall_kick_movement()
	handle_wall_jump_end()
	handle_animation()
	
func handle_animation():
		pass
	##if not player.move_left and player.move_right and should_enable_walk_kick:
		#player.anim.play("wall_kick")
	#else:
		#player.anim.play("wall_jump")

func should_only_jump_button_wall_kick(should_enable : bool): 
	should_enable_walk_kick = should_enable
	if should_enable_walk_kick:
		if player.move_left or player.move_right:
			player.velocity.x = player.WALL_JUMP_H_SPEED * player.wall_direction.x * -1
		else: 
			if player.jumps_taken == player.MAX_JUMPS:
				player.velocity.x = player.WALL_JUMP_H_SPEED * player.wall_direction * -1
			else: 
				state_machine.change_state(state_machine.FALL)
	else: 
		player.velocity.x = player.WALL_JUMP_H_SPEED * player.wall_direction.x * -1

func handle_wall_kick_movement():
	if !player.move_left and !player.move_right:
		player.velocity.x = move_toward(player.velocity.x, 0, player.WALL_KICK_ACCEL)
	else:
		if last_wall_direction == Vector2.LEFT and player.move_right:
			player.h_movement(player.WALL_KICK_ACCEL, player.WALL_KICK_DECEL)
		elif last_wall_direction == Vector2.RIGHT and player.move_left:
			player.h_movement(player.WALL_KICK_ACCEL, player.WALL_KICK_DECEL)
	
func handle_wall_jump_end():
	if player.velocity.y >= player.WALL_JUMP_Y_SPEED_PEAK:
		state_machine.change_state(state_machine.FALL)
	
	if player.wall_direction != last_wall_direction and player.wall_direction != Vector2.ZERO:
		state_machine.change_state(state_machine.FALL)
		
