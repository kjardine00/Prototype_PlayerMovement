# extends CharacterBody2D
# class_name Box_Obj

# func _ready() -> void:
# 	# super()
# 	pass

# func _physics_process(delta: float) -> void:
# 	# super(delta)
# 	pass

# func _interact(interactor: Player):
# 	match state:
# 		states.IDLE:
# 			_pick_up(interactor)
# 		states.PICKED_UP:
# 			pass
# 		states.THROWN:
# 			pass
	
# func damage():
# 	pass 
	
## ===========================Throwable object script=========================================
# extends Env_obj

# @export_category("Connections")
# @export var interact_component : InteractComponent
# @export var inv_item_resource : InvItem

# @export_category("Properties")
# @export_group("Gravity")
# @export_range(0, 100) var gravity_str: float = 18.0
# @export_range(0.5, 3) var desc_gravity_factor: float = 2.3
# @export_range(600, 1200) var terminal_velocity = 1000

# var gravity_active: bool = true
# var applied_gravity: float
# var applied_terminal_vel: float


# func _ready() -> void:
# 	interact_component.interact.connect(_interaction_signal)
# 	interact_component.stop_interact.connect(_stop_interacting_signal)

# func _gravity():
# 	if velocity.y > 0:
# 		applied_gravity = gravity_str * desc_gravity_factor
# 	else: 
# 		applied_gravity = gravity_str
	
# 	if gravity_active:
# 		if velocity.y < terminal_velocity:
# 			velocity.y += applied_gravity
# 		elif velocity.y > terminal_velocity:
# 			velocity.y = terminal_velocity

# #region Interaction Signal Handling
# func _interaction_signal(interactor: Player):
# 	_interact(interactor)

# func _stop_interacting_signal():
# 	pass
# #endregion

# func _interact(interactor) -> void:
# 	pass

## ===========================Env object script=========================================
# extends CharacterBody2D

# @export_category("Connections")
# @export var interact_component : InteractComponent
# @export var inv_item_resource : InvItem

# @export_category("Properties")
# @export_group("Gravity")
# @export_range(0, 100) var gravity_str: float = 18.0
# @export_range(0.5, 3) var desc_gravity_factor: float = 2.3
# @export_range(600, 1200) var terminal_velocity = 1000

# var gravity_active: bool = true
# var applied_gravity: float
# var applied_terminal_vel: float


# func _ready() -> void:
# 	interact_component.interact.connect(_interaction_signal)
# 	interact_component.stop_interact.connect(_stop_interacting_signal)

# func _gravity():
# 	if velocity.y > 0:
# 		applied_gravity = gravity_str * desc_gravity_factor
# 	else: 
# 		applied_gravity = gravity_str
	
# 	if gravity_active:
# 		if velocity.y < terminal_velocity:
# 			velocity.y += applied_gravity
# 		elif velocity.y > terminal_velocity:
# 			velocity.y = terminal_velocity

# #region Interaction Signal Handling
# func _interaction_signal(interactor: Player):
# 	_interact(interactor)

# func _stop_interacting_signal():
# 	pass
# #endregion

# func _interact(interactor) -> void:
# 	pass
