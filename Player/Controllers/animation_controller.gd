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


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if facing:
		player_sprite.flip_h = handle_direction()

func play_anim(animation_name : String):
	if anim_player.has_animation(animation_name):
		anim_player.play(animation_name)


func handle_direction():
	if facing == Vector2.RIGHT:
		return false
	elif facing == Vector2.LEFT:
		return true
