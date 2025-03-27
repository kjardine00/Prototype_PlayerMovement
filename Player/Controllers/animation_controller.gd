extends Node2D
class_name Animation_Controller

@onready var anim_player: AnimationPlayer = $PlayerAnimations
@onready var player_sprite: Sprite2D = $PlayerSprite

## Maps state names to animation names
## Animation names must be lowercase
@export_category("Animation Names")
@export var IDLE_ANIM := "idle"
@export var WALKING_ANIM := "walk" 
@export var JUMPING_ANIM := "jump"
@export var FALLING_ANIM := "fall"
@export var WALL_JUMPING_ANIM := "wall_jump"
@export var WALL_SLIDING_ANIM := "wall_slide"
@export var ROLLING_ANIM := "roll"
@export var DASHING_ANIM := "dash"

var facing

func play_anim(state: State) -> void:
	var anim_name: String = ""
	match state:
		state.state_machine.IDLING:
			anim_name = IDLE_ANIM
		state.state_machine.WALKING:
			anim_name = WALKING_ANIM
		state.state_machine.JUMPING:
			anim_name = JUMPING_ANIM
		state.state_machine.FALLING:
			anim_name = FALLING_ANIM
		state.state_machine.WALL_JUMPING:
			anim_name = WALL_JUMPING_ANIM
		state.state_machine.WALL_SLIDING:
			anim_name = WALL_SLIDING_ANIM
		state.state_machine.ROLLING:
			anim_name = ROLLING_ANIM
		state.state_machine.DASHING:
			anim_name = DASHING_ANIM
	
	if anim_player.has_animation(anim_name):
		anim_player.play(anim_name)

func handle_direction(x_dir):
	if x_dir != 0:
		player_sprite.flip_h = x_dir < 0
