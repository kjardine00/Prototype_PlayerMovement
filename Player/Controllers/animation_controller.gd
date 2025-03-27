extends Node2D
class_name Animation_Controller

@export var player_character: Player

@onready var anim_player: AnimationPlayer = $PlayerAnimations
@onready var player_sprite: Sprite2D = $PlayerSprite

## Maps state names to animation names
## Animation names must be lowercase
const IDLE_ANIM := "Idle"
const WALKING_ANIM := "Walk"
const WALL_JUMPING_ANIM := "WallJump"
const WALL_SLIDING_ANIM := "WallSlide"
const JUMP_FALL_ANIM := "JumpFall"
const JUMP_MID_ANIM := "JumpMid"
const JUMP_RISE_ANIM := "JumpRise"

const LANDING_ANIM := "Land"
const SPIN_ANIM := "Spin"

## =============================NOT Implemented Yet=============================
const ROLLING_ANIM := "Roll"
const DASHING_ANIM := "Dash"
const DASH_START_ANIM := "DashStart"
const DASH_LOOP_ANIM := "DashLoop"
const DASH_END_ANIM := "DashEnd"
const LOOK_UP_ANIM := "LookUp"
const CROUCH_ANIM := "Crouch"
const CRAWL_ANIM := "Crawl"
const LADDER_CLIMB_ANIM := "LadderClimb"
const LADDER_CLIMB_FINISH_ANIM := "LadderClimbFinish"
const SLIDE_ANIM := "Slide"
# const LOOK_DOWN_ANIM := "LookDown" #TODO Create this animation

var facing

func play_anim(state: State, idle_for_awhile: bool = false) -> void:
	var anim_name: String = ""
	match state:
		state.state_machine.IDLING:
			if idle_for_awhile:
				anim_name = SPIN_ANIM
			else:
				anim_name = IDLE_ANIM
		state.state_machine.WALKING:
			anim_name = WALKING_ANIM
		state.state_machine.JUMPING:
			if player_character.velocity.y < 0:
				anim_name = JUMP_RISE_ANIM
			elif player_character.velocity.y == 0:
				anim_name = JUMP_MID_ANIM
			else:
				anim_name = JUMP_FALL_ANIM
		state.state_machine.FALLING:
			anim_name = JUMP_FALL_ANIM
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

func transition_animation(prev_state: State, next_state: State):
	var anim_name: String = ""
	match prev_state:
		prev_state.state_machine.FALLING:
			if next_state.state_machine.IDLING or next_state.state_machine.WALKING:
				anim_name = LANDING_ANIM
	
	if anim_player.has_animation(anim_name):
		anim_player.play(anim_name)
		await anim_player.animation_finished

func handle_direction(x_dir):
	if x_dir != 0:
		player_sprite.flip_h = x_dir < 0
