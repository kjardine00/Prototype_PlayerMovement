extends CharacterBody2D

# NOTE: Features to implement
#var damage
#var cooldown
#var icon
#var attack_anim
#var combo_anim
#var damage_type
#var rotate on throw
# TODO rotate when thrown up and it falls down

#region Export VAR
@export_category("Connections")
@export var interact_component : InteractComponent
@export var hitbox : CollisionShape2D

@export_category("Properties")
@export_group("UI Elements")
## Must be a square icon with dimensions 0x0 px
@export var icon : Texture

@export_group("Gravity")
@export_range(0, 100) var gravity_str: float = 18
@export_range(0.5, 3) var desc_gravity_factor: float = 2.3
@export_range(600, 1200) var terminal_velocity = 1000

var gravity_active: bool = true
var applied_gravity: float
var applied_terminal_vel: float

@export_group("Throwing and Dropping")
@export var h_throw_velocity = Vector2(1600, -600)
@export var v_throw_velocity = Vector2(0, 600)
@export var drop_velocity = Vector2(0, 300)
@export var bounciness : float = 0.3
@export var oriented_throw : bool = true

enum states {IDLE, PICKED_UP, THROWN}
var state
var picked_up = false
#endregion

func _ready() -> void:
	interact_component.interact.connect(_interaction_signal)
	interact_component.stop_interact.connect(_stop_interacting_signal)
	
	state = states.IDLE

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

func _interact(interactor) -> void:
	match state:
		states.IDLE:
			_pick_up(interactor)
			state = states.PICKED_UP
		states.PICKED_UP:
			pass
		states.THROWN:
			pass
	
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
			rotation = velocity.angle()
			if collision != null:
				_on_impact(collision.get_normal())
			_check_idle()
			
#region Pick up
func _pick_up(interactor):
	if Global.player_inventory.empty_active:
		reparent(Global.player_inventory.active_item)
		Global.player_inventory.pickup(self)
		set_physics_process(false)
		global_position = get_parent().global_position
		state = states.PICKED_UP
		hitbox.disabled = true
		self.visible = false
	else:
		# TODO: If if feels better to auto stow a new item on pickup if active is full then do that here
		pass
#endregion

#region Throw/Drop Logic
func throw_drop(throw_direction):
	var scene = get_tree().current_scene
	var temp = global_transform
	get_parent().remove_child(self)
	scene.add_child(self)
	global_transform = temp
	state = states.THROWN
	set_physics_process(true)
	hitbox.disabled = false
	set_collision_mask_value(2, false)
	self.visible = true
	
	match throw_direction:
		Vector2.ZERO:
			velocity = drop_velocity * Vector2.UP
		Vector2.UP:
			velocity.y = v_throw_velocity.y * throw_direction.y
			#print_debug(velocity, "up")
		Vector2.DOWN:
			velocity.y = v_throw_velocity.y * throw_direction.y * 0.5
			#print_debug(velocity, "down")
		Vector2.LEFT:
			velocity.x = h_throw_velocity.x * throw_direction.x
			velocity.y = h_throw_velocity.y
			#print_debug(velocity, "Left")
		Vector2.RIGHT:
			velocity.x = h_throw_velocity.x * throw_direction.x
			velocity.y = h_throw_velocity.y
			#print_debug(velocity, "right")
	#print_debug("Throw " + str(throw_direction))
	
func _on_impact(normal : Vector2):
	velocity = velocity.bounce(normal)
	velocity *= 0.1 + randf_range(-0.05, 0.05)

func _check_idle():
	if abs(velocity.x) < 0.1:
		state = states.IDLE
		set_collision_mask_value(2, false)
#endregion

#region Attack Logic
func attack(attack_direction):
	#TODO 
	# Play animation
	# Toggle on Hitbox with damage info
	# Toggle
	match attack_direction:
		Vector2.ZERO:
			pass
		Vector2.UP:
			pass
		Vector2.DOWN:
			pass
		Vector2.LEFT:
			pass
		Vector2.RIGHT:
			pass

#endregion
