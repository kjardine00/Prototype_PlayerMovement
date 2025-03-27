extends State

## WALL_JUMP State

func enter_state():
	player.movement_handler.wall_jump()

func handle_movement_input(direction: Vector2):
	player.movement_handler.set_x_direction(direction.x)
