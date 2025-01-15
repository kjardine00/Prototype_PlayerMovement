extends State

## WALL_JUMP State

var last_wall_direction
var should_enable_walk_kick

func enter_state():
	pass
	
func exit_state():
	pass
	
func update(delta: float):
	handle_animation("wall_jump")

func _handle_wall_jump_transition():
	if player.velocity.y >= 0:
		state_machine.change_state(state_machine.FALL)
	
	if player.movement_controller.wall_dir != last_wall_direction and player.movement_controller.wall_dir != Vector2.ZERO:
		state_machine.change_state(state_machine.FALL)
