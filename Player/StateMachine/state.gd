extends Node
class_name State

var state_machine: State_Machine
var player : Player 

func enter_state():
	pass
	
func exit_state():
	pass
	
func update(_delta: float):
	handle_animation(state_machine.current_state)

func handle_animation(animation: State):
	state_machine.player_character.anim_controller.play_anim(animation)

func enter_animation(animation: State):
	state_machine.player_character.anim_controller.enter_animation(animation)

func exit_animation(animation: State):
	state_machine.player_character.anim_controller.exit_animation(animation)

func handle_movement_input(direction):
	player.movement_handler.set_x_direction(direction.x)

	if direction.y < 0:
		match state_machine.current_state:
			state_machine.FALLING:
				player.movement_handler.fast_fall()
			state_machine.WALL_JUMPING:
				player.movement_handler.fast_fall()
			state_machine.JUMPING:
				player.movement_handler.fast_fall()
			_:
				pass

func handle_jump_input():
	if player.num_of_available_jumps > 0:
		if state_machine.current_state == state_machine.WALL_SLIDING:
			state_machine.change_state(state_machine.WALL_JUMPING)
			# Clear both jump buffers when wall jumping
			state_machine.jump_is_buffered = false
			state_machine.wall_jump_is_buffered = false
		else:
			state_machine.change_state(state_machine.JUMPING)
			# Clear the jump buffer when we successfully jump
			state_machine.jump_is_buffered = false

func handle_ability_input(ability_type: BodyEquip.AbilityType):
	match ability_type:
		BodyEquip.AbilityType.ROLL:
			state_machine.change_state(state_machine.ROLLING)
		BodyEquip.AbilityType.DASH:
			state_machine.change_state(state_machine.DASHING)
		# BodyEquip.AbilityType.GLIDE:
		# 	state_machine.change_state(state_machine.GLIDING)
		# BodyEquip.AbilityType.BLINK:
		# 	state_machine.change_state(state_machine.BLINKING)
		# BodyEquip.AbilityType.FLY:
		# 	state_machine.change_state(state_machine.FLYING)
		# BodyEquip.AbilityType.BARRIER:
		# 	state_machine.change_state(state_machine.BARRIER)
