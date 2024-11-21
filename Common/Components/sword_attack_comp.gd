extends Area2D
class_name Attack_Component

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d_2: Sprite2D = $Sprite2D2
@onready var timer: Timer = $Timer

@export var anim_timer: float = 0.1

var player: Player

func _ready() -> void:
	player = get_parent()
	sprite_2d_2.visible = false

func _physics_process(delta: float) -> void:
	pass

func attack(item: InvItem):

	sprite_2d_2.visible = true
	if player.handle_direction():
		sprite_2d_2.position.x = -12
		sprite_2d_2.rotation = PI * 1.25
	elif not player.handle_direction():
		sprite_2d_2.position.x = 12
		sprite_2d_2.rotation = PI * 0.25
	timer.start(anim_timer)

func _on_timer_timeout() -> void:
	sprite_2d_2.visible = false
