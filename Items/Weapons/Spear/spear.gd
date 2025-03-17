extends CharacterBody2D
class_name Weapon
#NOTE: Features to implement
#var combo_anim
#var rotate on throw
#TODO orient correctly when thrown

#region Export VAR
@export_category("Connections")
@export var interact_component : InteractComponent
@export var hitbox : CollisionShape2D
@export var sprite: Sprite2D
@export var damage_comp: DamageComp

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

@export_group("Attack and Damage")
@export var damage : float
@export var cooldown : float
@export var can_damage : bool = false
@export var spear_range : float = 65

enum states {IDLE, PICKED_UP, THROWN}
var state

#endregion

func _ready() -> void:
	interact_component.interact.connect(_interaction_signal)
	interact_component.stop_interact.connect(_stop_interacting_signal)
	
	damage_comp.damage = damage
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
func _interaction_signal(interactor: Player) -> void:
	match state:
		states.IDLE:
			_pick_up(interactor)
			state = states.PICKED_UP
		states.PICKED_UP:
			pass
		states.THROWN:
			pass

func _stop_interacting_signal():
	pass
#endregion
	
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
func _pick_up(_interactor):
	if !Global.player_inventory.active_item:
		#Sends its node and a reference to itself to the inventory controller
		reparent(Global.player_inventory.active_item_node)
		Global.player_inventory.set_active(self)
		#turns the object in the world off
		set_physics_process(false)
		global_position = get_parent().global_position
		state = states.PICKED_UP
		hitbox.disabled = true
		self.visible = false
		rotation = 0
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
func attack(facing : Vector2 = Vector2.RIGHT, attack_direction : Vector2 = Vector2.ZERO):
	#TODO 
	# Play animation
	# Toggle on Hitbox with damage info
	# Toggle
	match attack_direction:
		Vector2.ZERO:
			h_attack(facing)
		Vector2.UP:
			pass
		Vector2.DOWN:
			pass
		Vector2.LEFT:
			h_attack(attack_direction)
		Vector2.RIGHT:
			h_attack(attack_direction)

func h_attack(dir):
	if dir == Vector2.LEFT:
		sprite.flip_h = true
		damage_comp.position = spear_range * dir
	elif dir == Vector2.RIGHT:
		sprite.flip_h = false
		damage_comp.position = spear_range * dir
		
	var tween = get_tree().create_tween()
	self.visible = true
	tween.tween_property(self, "position", Vector2(spear_range, 0) * dir, 0.1)
	tween.tween_property(self, "position", Vector2(0, 0), 0.1)
	await get_tree().create_timer(0.2).timeout
	self.visible = false

func v_attack(dir):
	var tween = get_tree().create_tween()
	self.visible = true
	await get_tree().create_timer(0.2).timeout
	self.visible = false
#endregion
