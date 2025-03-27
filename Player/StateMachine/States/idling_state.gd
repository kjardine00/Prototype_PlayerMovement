extends State

## IDLE State

var idle_for_awhile: bool = false

func enter_state():
	player.movement_handler.set_x_direction(0)
	player.reset_num_jumps()
	player.anim_controller.transition_animation(state_machine.prev_state, self)
	_idle_time(60 * 3)

func exit_state():
	idle_for_awhile = false

func update(delta: float):
	if idle_for_awhile:
		player.anim_controller.play_anim(state_machine.current_state, true)
	else: 
		handle_animation(state_machine.current_state)

func _idle_time(time):
	await get_tree().create_timer(time).timeout
	idle_for_awhile = true