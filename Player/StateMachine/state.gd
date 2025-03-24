extends Node
class_name State

var state_machine: State_Machine
var player : Player 

func enter_state():
	pass
	
func exit_state():
	pass
	
func update(_delta: float):
	player.movement_handler.set_x_direction(state_machine.input_direction.x)
	
func handle_animation(anim_name : String):
	pass
	#state_machine.player_character.anim_controller.play_anim(anim_name)

func handle_movement_input(direction):
	state_machine.input_direction = direction
	if state_machine.input_direction.x == 0 && player.is_on_floor():
		state_machine.change_state(state_machine.IDLING)

func handle_jump_input():
	if state_machine.current_state == state_machine.WALL_SLIDING:
		state_machine.change_state(state_machine.WALL_JUMPING)
			
	elif state_machine.current_state != state_machine.JUMPING:
		state_machine.change_state(state_machine.JUMPING)

func handle_wall_slide_tranisition():
	if !player.is_on_floor() and player.wall_jump:
		if player.is_on_wall():
## check if the player is in contact with either wall side and holding the coresponding direction otherwise -> fall state
			if (state_machine.input_direction == Vector2.LEFT and player.wall_detector.is_colliding()):
				state_machine.change_state(state_machine.WALL_SLIDING)
			elif (state_machine.input_direction == Vector2.RIGHT and player.wall_detector.is_colliding()):
				state_machine.change_state(state_machine.WALL_SLIDING)

func handle_ability_input(ability_type : BodyEquip.AbilityType):
	match ability_type:
		BodyEquip.AbilityType.DASH:
			print_debug("State machine state change to dashing")
			state_machine.change_state(state_machine.DASHING)
