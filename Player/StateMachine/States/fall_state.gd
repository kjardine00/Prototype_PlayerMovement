extends State

## FALL State

func enter_state():
	pass
	
func exit_state():
	pass
	
func update(delta: float):
	player.handle_gravity(delta, player.GRAVITY_FALL)
	player.h_movement(player.AIR_ACCEL, player.AIR_DECEL)
	player.handle_landing()
	player.handle_jump()
	player.handle_jump_buffer()
	player.handle_wall_jump()
	player.handle_wall_slide()
	handle_animation()
	
func handle_animation():
	player.anim.play("fall")
	player.handle_flip_h()
