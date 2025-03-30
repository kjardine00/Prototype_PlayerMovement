extends State

## ROLLING State

var roll_timer: float = 0.0
var last_direction : Vector2

func enter_state():
	player.movement_handler.roll(last_direction)
	roll_timer = player.movement_handler.roll_duration
	handle_animation(state_machine.current_state)

func exit_state():
	roll_timer = 0.0
	player.velocity.x = 0  # Reset horizontal velocity after roll

func update(delta: float):
	roll_timer -= delta

##TODO: Add i_frames to the rolling state

#region Ignore Inputs
func handle_movement_input(_direction: Vector2):
	pass

func handle_ability_input(_ability_type: BodyEquip.AbilityType):
	pass
#endregion
