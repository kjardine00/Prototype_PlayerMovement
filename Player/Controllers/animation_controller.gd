extends Node2D
class_name Animation_Controller

@onready var anim_player: AnimationPlayer = $PlayerAnimations
@onready var player_sprite: Sprite2D = $PlayerSprite

##TODO this bool has no function?
##Animations must be named exactly in all lowercase
@export_category("Animations (Check if has animation)")
@export var idle : bool
@export var run : bool
@export var jump : bool
@export var fall : bool
@export var walk : bool
@export var slide : bool
@export var crouch_idle : bool
@export var crouch_walk : bool
@export var roll : bool
#@export var : bool

var facing

func play_anim(animation_name : String):
	if anim_player.has_animation(animation_name):
		anim_player.play(animation_name)

func handle_direction(x_dir):
	if x_dir != 0:
		player_sprite.flip_h = x_dir < 0
