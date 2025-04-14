extends Area2D
class_name TreasureChest

@export_category("Connections")
@export var chest_sprite : Sprite2D
@export var interaction_component : InteractComponent
@export var hitbox : CollisionShape2D
var closed_chest_hitbox_dimensions : Vector2 = Vector2(33, 22)
var open_chest_hitbox_dimensions : Vector2 = Vector2(33, 16)

@export_category("Contents")
@export var num_coins : int = 0
@export var coin_scene : PackedScene    
@export var num_keys : int = 0
@export var key_scene : PackedScene
@export var contents : Array[PackedScene] = []
@export var jump_force : float = 200.0
@export var spread_angle : float = 45.0
var is_open: bool = false

func _ready():
	interaction_component.interact.connect(_open_chest)
	interaction_component.remove_after_interact = true
	hitbox.shape.size = closed_chest_hitbox_dimensions
	chest_sprite.frame = 0

func _open_chest(_interactor: Player):
	# print("opening chest")
	is_open = true
	chest_sprite.frame = 1
	hitbox.shape.size = open_chest_hitbox_dimensions
	
	interaction_component.set_deferred("monitoring", false)
	interaction_component.set_deferred("monitorable", false)

	empty_chest()

func spawn_item(item_scene: PackedScene, angle: float, num_items: int = 1):
	for i in num_items:
		var item = item_scene.instantiate()
		get_parent().add_child(item)
		item.position = global_position
		var direction = Vector2.RIGHT.rotated(deg_to_rad(angle))
		item.velocity = direction * jump_force

func empty_chest():
	if num_coins > 0:
		# print_debug("spawning coins: ", num_coins)
		var angle = randf_range(-spread_angle, spread_angle)
		spawn_item(coin_scene, angle, num_coins)
		num_coins = 0
	
	if num_keys > 0:
		print_debug("spawning keys: ", num_keys)
		var angle = randf_range(-spread_angle, spread_angle)
		spawn_item(key_scene, angle, num_keys)
		num_keys = 0
	
	if contents.size() > 0:
		for i in contents:
			print_debug("spawning contents: ", i)
			var angle = randf_range(-spread_angle, spread_angle)
			spawn_item(i, angle)

	contents.clear() 
