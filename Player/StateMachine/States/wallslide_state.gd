extends State

## WALL_SLIDE State

@export var wall_magnet_speed: float = 50

func enter_state():
	if player.wall_direction == Vector2.LEFT:
		player.velocity.x = -wall_magnet_speed
	elif player.wall_direction == Vector2.RIGHT:
		player.velocity.x = wall_magnet_speed
	
	
func exit_state():
	pass
	
func update(delta: float):
	player.get_wall_direction()
	player.handle_landing()
	player.handle_wall_jump()
	player.handle_flip_h()
	handle_wall_slide_movement()
	handle_animation()
	
func handle_animation():
	player.anim.play("wall_slide")

func handle_wall_slide_movement():
	if player.wall_direction == Vector2.ZERO:
		state_machine.change_state(state_machine.FALL)
	
	if (player.wall_direction == Vector2.LEFT and player.move_left) or (player.wall_direction == Vector2.RIGHT and player.move_right):
		if not player.action_down:
			player.velocity.y = player.WALL_SLIDE_SPEED
		else:
			state_machine.change_state(state_machine.FALL)
