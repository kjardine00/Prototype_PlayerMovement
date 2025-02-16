extends Area2D
class_name Attack_Component

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var weapon_sprite: Sprite2D = $WeaponSprite

#OLD NO ANIMATION Sprite
@onready var sprite_2d_2: Sprite2D = $Sprite2D2

const sword_anim_1 = "sword_slash"

var player: Player

func _ready() -> void:
	player = get_parent()
	sprite_2d_2.visible = false

func _physics_process(_delta: float) -> void:
	pass

func attack(item: InvItem):
	if player.handle_direction():
		#weapon_sprite.position.x = -6
		weapon_sprite.flip_h = true
	elif not player.handle_direction():
		#weapon_sprite.position.x = 6
		weapon_sprite.flip_h = false
		
	animation_player.play(sword_anim_1)
