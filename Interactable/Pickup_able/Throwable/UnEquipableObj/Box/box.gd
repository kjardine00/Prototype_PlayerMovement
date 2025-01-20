extends CharacterBody2D
class_name Box_Obj

@onready var hitbox: CollisionShape2D = $Hitbox

@export_category("Connections")
@export var interact_component : InteractComponent
@export var inv_item_resource : InvItem

@export_category("Pick Up Variables")
## If the player can equip the item as an equipment i.e. armor, charms, boots etc.
@export var CAN_EQUIP: bool = false
##If the player can stow the item in the players non-active hand slot
@export var CAN_STOW: bool = false

@export_category("Properties")
@export_group("Gravity")
@export_range(0, 100) var gravity_str: float = 18.0
@export_range(0.5, 3) var desc_gravity_factor: float = 2.3
@export_range(600, 1200) var terminal_velocity = 1000
@export_group("Throwing")
@export var throw_velocity = Vector2(1200, -1200)
@export var bounciness : float = 0.3

var gravity_active: bool = true
var applied_gravity: float
var applied_terminal_vel: float

enum states {IDLE, PICKED_UP, THROWN}
var state
var picked_up = false

func _ready() -> void:
	state = states.IDLE
	
	interact_component.interact.connect(_interaction_signal)
	interact_component.stop_interact.connect(_stop_interacting_signal)

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
	
func _gravity():
	if velocity.y > 0:
		applied_gravity = gravity_str * desc_gravity_factor
	else: 
		applied_gravity = gravity_str
	
	if gravity_active:
		if velocity.y < terminal_velocity:
			velocity.y += applied_gravity
		elif velocity.y > terminal_velocity:
			velocity.y = terminal_velocity

#region Interaction Signal Handling
func _interaction_signal(interactor: Player):
	_interact(interactor)

func _stop_interacting_signal():
	pass

#endregion

func _interact(interactor: Player):
	match state:
		states.IDLE:
			_pick_up(interactor)
		states.PICKED_UP:
			_throw(interactor.h_dir)
		states.THROWN:
			pass

#region Pick up
func _pick_up(interactor):
	if interactor.has_node("GrabPos"):
		var grab_position = interactor.get_node("GrabPos")
		reparent(grab_position)
		set_physics_process(false)
		global_position = get_parent().global_position
		state = states.PICKED_UP
		hitbox.disabled = true
#endregion

#region Throw Logic
func _throw(direction):
	var temp = global_transform
	var scene = get_tree().current_scene
	get_parent().remove_child(self)
	scene.add_child(self)
	global_transform = temp
	set_physics_process(true)
	velocity = throw_velocity * direction
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
	
func damage():
	pass
	
