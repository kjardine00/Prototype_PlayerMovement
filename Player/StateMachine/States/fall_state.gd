extends State

## FALL State

func enter_state():
	pass
	
func exit_state():
	pass
	
func update(delta: float):
	player.movement_controller.handle_gravity(delta, player.movement_controller.gravity)
	player.movement_controller.h_movement(delta)
	player.movement_controller.handle_landing()
	player.movement_controller.handle_jump()
	player.movement_controller.handle_climb()
	player.movement_controller.handle_jump_buffer()
	player.movement_controller.handle_wall_jump()
	player.movement_controller.handle_wall_slide()
	handle_animation("fall")
