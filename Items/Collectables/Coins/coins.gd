extends CharacterBody2D
class_name Coin

signal coin_collected

@export var hitbox: CollisionShape2D
@export var coin_sprite: Sprite2D

func _ready() -> void:
	coin_collected.connect(Global.player_inventory.add_coin)

func _on_collection_area_2d_body_entered(_body:Player) -> void:
	coin_collected.emit()
	queue_free()
