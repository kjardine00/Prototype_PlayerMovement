extends CharacterBody2D
class_name EnvObject

@export var debug: bool
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var trajectory_line: Line2D = $TrajectoryLine


@export_category("Connections")
@export var interact_component : InteractComponent
@export var inv_resource: InvItem

@export_category("Properties")
var inv_item: InvItem
var dir: Vector2 = Vector2.ZERO
var speed: float
var bounce_dampen: float = 0.6

@export_category("Pick Up Variables")
@export var CAN_EQUIP: bool = false
@export var CAN_STOW: bool = false
@export var EQUIPPED: bool = false
var GRABBED_POS: Marker2D


func _ready() -> void:
	interact_component.interact.connect(_interaction_signal)
	interact_component.stop_interact.connect(_stop_interacting_signal)


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if debug:
		trajectory_line.visible = true
		print("Velocity " + str(self.velocity))
	else: 
		trajectory_line.visible = false
	
	if not is_on_floor() && not EQUIPPED:
		velocity += get_gravity() * delta
	
	# Pickup logic
	if GRABBED_POS:
		if CAN_EQUIP:
			if not EQUIPPED:
				pass
			elif EQUIPPED:
				self.global_position = GRABBED_POS.global_position
	
	move_and_slide()

## TODO FIGURE OUT IF THIS IS THE RIGHT WAY TO DO THIS
#func throw_or_drop(interactor):
	#var h_direction = interactor.velocity.x
	#var collision
	#
	#if h_direction == 0:
		### just drop
		#collision = move_and_collide(Vector2(0, -0.5))
	#else:
		### throw the obj
		#collision = move_and_collide(velocity)
		#if not collision:
			#return
	#velocity = velocity.bounce(collision) * bounce_dampen


func _interaction_signal(interactor: Player):
	
	var player_inv = interactor.inventory	
	#GRABBED_POS = interactor.get_node("GrabPos")
	
	if CAN_EQUIP:
		if EQUIPPED:
			#throw_or_drop(interactor)
			EQUIPPED = false
			player_inv.items.erase(inv_resource)
		else:
			EQUIPPED = true
			player_inv.items.push_front(inv_resource)


func _stop_interacting_signal():
	pass
