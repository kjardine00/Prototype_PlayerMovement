extends Env_obj
class_name Throwable_obj

@export_category("Connections")
@export var hitbox : CollisionShape2D

@export_category("Properties")
@export_group("Throwing")
@export var throw_velocity = Vector2(1200, -1200)
@export var bounciness : float = 0.3

enum states {IDLE, PICKED_UP, THROWN}
var state
var picked_up = false

func _ready() -> void:
	super() # Replace with function body.
	state = states.IDLE
	
func _physics_process(delta: float) -> void:
	match state:
		states.IDLE:
			_gravity()
			move_and_slide()
		states.PICKED_UP:
			pass
		states.THROWN:
			_gravity()
			var collision = move_and_collide(velocity * delta)
			if collision != null: 
				_on_impact(collision.get_normal())
			_check_idle()
			
#region Pick up
func _pick_up(interactor):
	##TODO REFACTOR = need to place self into inventory awaiting player input
	if interactor.has_node("InventoryController"):
		
		var player_inv = interactor.get_node("InventoryController")
		player_inv.pick_up(self)
		reparent(player_inv)
		
		
		set_physics_process(false)
		global_position = get_parent().global_position
		state = states.PICKED_UP
		hitbox.disabled = true
#endregion

#region Throw Logic
func throw(interactor: Player):
	var temp = global_transform
	var scene = get_tree().current_scene
	get_parent().remove_child(self)
	scene.add_child(self)
	global_transform = temp
	set_physics_process(true)
	velocity = throw_velocity * interactor.h_dir
	state = states.THROWN
	hitbox.disabled = false
	set_collision_mask_value(2, false)

func _on_impact(normal : Vector2):
	velocity = velocity.bounce(normal)
	velocity *= 0.3 + randf_range(-0.05, 0.05)

func _check_idle():
	if abs(velocity.x) < 0.1:
		state = states.IDLE
		set_collision_mask_value(2, false)
#endregion
