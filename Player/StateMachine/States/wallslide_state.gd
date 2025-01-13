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
	player.movement_controller.get_wall_direction()
	player.movement_controller.handle_landing()
	player.movement_controller.handle_climb()
	player.movement_controller.handle_wall_jump()
	handle_wall_slide_movement()
	handle_animation("wall_slide")


func handle_wall_slide_movement():
	if player.wall_direction == Vector2.ZERO:
		player.state_machine.change_state(player.state_machine.FALL)
	
	if ((player.wall_direction == Vector2.LEFT and player.input_controller.left_hold) or (player.wall_direction == Vector2.RIGHT and player.input_controller.right_hold)):
		if not player.input_controller.action_down_hold:
			player.velocity.y = player.WALL_SLIDE_SPEED
	else:
		player.state_machine.change_state(player.state_machine.FALL)
