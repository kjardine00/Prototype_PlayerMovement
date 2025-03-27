extends State

## FALL State

func enter_state():
	pass

func update(_delta: float):
	# Check for fast fall input
	if Input.is_action_pressed("move_down"):
		player.movement_handler.fast_fall()

func handle_jump_released():
	player.movement_handler.cut_jump()
