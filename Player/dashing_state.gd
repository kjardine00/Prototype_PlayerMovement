extends State

## DASHING State

var dash_finished: bool = false

func enter_state():
	state_machine.player_character.movement_handler.dash()

func update(delta):
	super(delta)
	tranistion_logic()

func transisition_to_fall_state():
	if player.velocity.y >= 0:
		player.state_machine.change_state(state_machine.FALLING)

func tranistion_logic():
	if player.is_on_floor() && player.velocity.x > 0 && dash_finished:
		player.state_machine.change_state(state_machine.WALKING)
	transisition_to_fall_state()
# Dashing to what states
# Idle happens in parent state
# Walk
# Jump is in base state
# Fall is
# Wall Slide in base state

# States that can get to dashing
# all of them? 
