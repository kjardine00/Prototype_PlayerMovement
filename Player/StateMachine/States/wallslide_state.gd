extends State

## WALL_SLIDE State

func enter_state():
	pass
	
func exit_state():
	pass
	
func update(delta: float):
	handle_animation("wall_slide")

func _handle_wall_slide_tranisition(delta):
	##If the player is no longer in contact with the wall -> fall state
	if player.movement_controller.wall_dir == Vector2.ZERO:
		player.state_machine.change_state(player.state_machine.FALL)
	
## check if the player is in contact with either wall side and holding the coresponding direction otherwise -> fall state
	if (player.movement_controller.wall_dir == Vector2.LEFT and player.input_controller.left_hold):
		player.movement_controller.wall_slide(delta)
	elif (player.movement_controller.wall_dir == Vector2.RIGHT and player.input_controller.right_hold):
		player.movement_controller.wall_slide(delta)
	else:
		player.state_machine.change_state(player.state_machine.FALL)
