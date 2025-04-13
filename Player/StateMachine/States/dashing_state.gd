extends State

## DASHING State

var dash_timer: float = 0.0
var last_direction : Vector2

func enter_state():
	player.velocity = Vector2.ZERO
	player.movement_handler.dash(last_direction)
	dash_timer = player.movement_handler.dash_duration
	handle_animation(state_machine.current_state)

func exit_state():
	dash_timer = 0.0
	player.velocity.x = 0 

func update(delta: float):
	dash_timer -= delta

##TODO: Add i_frames to the dashing state

#region Ignore Inputs
func handle_ability_input(_ability_type: BodyEquip.AbilityType):
	pass
#endregion