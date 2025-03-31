extends Node

@onready var input_handler: InputHandler = $InputHandler

func _ready() -> void:
	input_handler.active_device_changed.connect(active_device_changed)
	input_handler.h_move.connect(h_move)
	input_handler.v_move.connect(v_move)
	input_handler.jump.connect(jump)
	input_handler.interact.connect(interact)
	input_handler.attack.connect(attack)
	input_handler.swap_active.connect(swap_active)
	input_handler.throw_drop.connect(throw_drop)
	input_handler.use_ability.connect(use_ability)
	input_handler.use_charm.connect(use_charm)

func debug(type):
	print_debug("Signal Emitted ... ", type)


func active_device_changed(device):
	print_debug("active_device_changed ... ", device)
func h_move(direction : Vector2):
	#print_debug("h_move ... ", direction)
	pass
func v_move(direction: Vector2):
	#print_debug("h_move ... ", direction)
	pass
func jump():
	debug("jump")
func interact():
	debug("interact")
func attack(direction : Vector2):
	print_debug("h_move ... ", direction)
func swap_active():
	debug("swap_active")
func throw_drop(direction : Vector2):
	print_debug("h_move ... ", direction)
func use_ability(direction : Vector2):
	print_debug("h_move ... ", direction)
func use_charm(direction : Vector2):
	print_debug("h_move ... ", direction)
