extends CharacterBody2D
class_name Box_Obj

@export var debug: bool

@export_category("Connections")
@export var interact_component : InteractComponent

@export_category("Properties")
@export var GRAVITY_JUMP = 600

@export_category("Pick Up Variables")
@export var CAN_EQUIP: bool = false
@export var CAN_STOW: bool = false
@export var EQUIPPED: bool = false


var picked_up = false

func _ready() -> void:
	interact_component.interact.connect(_interaction_signal)
	interact_component.stop_interact.connect(_stop_interacting_signal)


func _physics_process(delta: float) -> void:
	
	if not is_on_floor() && not picked_up:
		handle_gravity(delta)
	
	move_and_slide()
	print(str(velocity))
	
func handle_gravity(delta, g: float = GRAVITY_JUMP):
	
		velocity.y += g * delta
		
#region Interaction Signal Handling
func _interaction_signal(interactor: Player):
	interact(interactor)

func _stop_interacting_signal():
	pass

#endregion

func interact(interactor: Player):
	## Setup so when the player presses interact this function is called to set the global position of this obj to the players marker2D
	
	pass
	
func throw_self():
	pass
	
func damage():
	pass
	



#func _physics_process(delta: float) -> void:
	## Add the gravity.
	#if not is_on_floor():
		#velocity += get_gravity() * delta
#
	## Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		#velocity.y = JUMP_VELOCITY
#
	## Get the input direction and handle the movement/deceleration.
	## As good practice, you should replace UI actions with custom gameplay actions.
	#var direction := Input.get_axis("ui_left", "ui_right")
	#if direction:
		#velocity.x = direction * SPEED
	#else:
		#velocity.x = move_toward(velocity.x, 0, SPEED)
#
	#move_and_slide()
