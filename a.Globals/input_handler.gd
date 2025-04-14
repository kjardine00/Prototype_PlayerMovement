extends Node

##These are the games contexts for inputs
enum DEVICE { KEYBOARD, JOYPAD }
enum CONTEXT { GAMEPLAY, MENU, DIALOGUE, CUTSCENE }

const DEADZONE = 0.2

## UI signals for Joypad or Keyboard
signal active_device_changed(device)

#region Gameplay Signals
## ====================== Gameplay Signals ====================================
signal movement_input(direction: Vector2)
signal jump
signal jump_released
signal interact
signal attack(direction : Vector2, last_h_direction : Vector2)
signal swap_active
signal throw_drop(direction : Vector2)
signal use_ability
signal use_charm(direction : Vector2)
##TODO rename this last btn input to its function before implemenation
#signal extra_btn
#endregion

#region Menu
## ====================== Menu Signals ====================================
#endregion

#region Dialogue
## ====================== Dialogue Signals ====================================
#endregion

#region Cutscene
## ====================== Cutscene Signals ====================================
#endregion

var current_context : CONTEXT
var current_device: DEVICE

var device_map = {
	"InputEventJoypadButton": DEVICE.JOYPAD,
	"InputEventJoypadMotion": DEVICE.JOYPAD,
	"InputEventKey" : DEVICE.KEYBOARD,
	}

var last_direction = Vector2.ZERO
var last_horizontal_direction = Vector2.RIGHT

func _input(event):
	var new_device = detect_device(event)
	if new_device != current_device:
		current_device = new_device
		active_device_changed.emit(current_device)

func _unhandled_input(event):
	match current_context:
		CONTEXT.GAMEPLAY:
			handle_gameplay_input(event)
		CONTEXT.MENU:
			handle_menu_input(event)
		CONTEXT.DIALOGUE:
			handle_dialogue_input(event)
		CONTEXT.CUTSCENE:
			handle_cutscene_input(event)

func detect_device(event: InputEvent) -> DEVICE:
	if event is InputEventJoypadMotion and abs(event.axis_value) < 0.2:
		return current_device
	
	for event_type in device_map.keys():
		if event.is_class(event_type):
			return device_map[event_type]
	return current_device

func set_context(new_context):
	current_context = new_context
	#print("Switched to new context: ", current_context)

func get_last_dir_input(_event) -> Vector2:
	if Input.is_action_pressed("move_up"):
		return Vector2.UP
	elif Input.is_action_pressed("move_down"):
		return Vector2.DOWN
	elif Input.is_action_pressed("move_left"):
		return Vector2.LEFT
	elif Input.is_action_pressed("move_right"):
		return Vector2.RIGHT
	else:
		return Vector2.ZERO


func get_last_h_dir(direction : Vector2) -> Vector2:
	if direction.x > 0:
		return Vector2.RIGHT
	else:
		return Vector2.LEFT

#region handle input based on context
func handle_gameplay_input(event):
	var raw_direction = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	)
	
	var direction = Vector2(
		0 if abs(raw_direction.x) < DEADZONE else raw_direction.x,
		0 if abs(raw_direction.y) < DEADZONE else raw_direction.y,
	)
	
	if direction != last_direction:
		last_direction = direction
		movement_input.emit(last_direction)
		# Only update last_horizontal_direction when there is actual movement
		if direction.x != 0:
			last_horizontal_direction = get_last_h_dir(direction)
	
	if Input.is_action_just_pressed("jump"):
		jump.emit()
	
	if Input.is_action_just_released("jump"):
		jump_released.emit()
	
	if Input.is_action_just_pressed("interact"):
		interact.emit()
		
	if Input.is_action_just_pressed("attack"):
		attack.emit(last_direction, last_horizontal_direction)
		print_debug(last_direction, last_horizontal_direction)
		
	if Input.is_action_just_pressed("swap_active"):
		swap_active.emit()
		
	if Input.is_action_just_pressed("throw_drop"):
		throw_drop.emit(get_last_dir_input(event))
		
	if Input.is_action_just_pressed("use_ability"):
		use_ability.emit(last_horizontal_direction)
		
	if Input.is_action_just_pressed("use_charm"):
		use_charm.emit(get_last_dir_input(event))

	if Input.is_action_just_pressed("pause"):
		Global.game_controller.pause_game()

	#if Input.is_action_just_pressed("extra_btn"):
		#extra_btn.emit(get_last_dir_input(event))

func handle_menu_input(_event):
	pass

func handle_dialogue_input(_event):
	pass
	
func handle_cutscene_input(_event):
	pass
	
#endregion
