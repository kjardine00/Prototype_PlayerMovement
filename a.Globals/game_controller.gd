extends Node
class_name GameController

@export var world_2d: Node2D
@export var ui: Control

@export var transition_controller: SceneTransitionController

var current_2d_scene : Node
var current_ui_scene : Node

func _ready() -> void:
	Global.game_controller = self
	change_ui_scene(SceneMap.MAIN_MENU, false, false)

#region 2D Scene Tranistions
func change_2d_scene(
	new_scene: String, 
	delete: bool = true, 
	keep_running: bool = false
	):

	if current_2d_scene:
		if delete:
			current_2d_scene.queue_free()
		elif keep_running:
			current_2d_scene.visible = false
		else:
			world_2d.remove_child(current_2d_scene)
			
	var new = load(new_scene).instantiate()
	world_2d.add_child(new)
	current_2d_scene = new
#endregion

#region UI Scene Tranistions
func change_ui_scene(
	new_scene: String, 
	delete: bool = true, 
	keep_running: bool = false
	):

	if current_ui_scene:
		if new_scene in ui.get_children():
			# new_scene.visible = true
			pass
		else:
			if delete:
				current_ui_scene.queue_free()
			elif keep_running:
				current_ui_scene.visible = false
			else:
				ui.remove_child(current_ui_scene)
			
	var new = load(new_scene).instantiate()
	ui.add_child(new)
	current_ui_scene = new
	# transition_controller.transition(transition_in, seconds)

func pause_game() -> void:
	if current_ui_scene is MainMenu:
		return
	else:
		get_tree().paused = true
		change_ui_scene(SceneMap.PAUSE_MENU, false, false)

#region Main Menu Actions
## Main Menu -> HUD, NONE -> AreaHub
func new_game() -> void:
	change_ui_scene(SceneMap.HUD, false, false)
	change_2d_scene(SceneMap.AREA_HUB, false, false)

## TODO: Save Feature needs to be implemented for this to be a feature
func continue_game() -> void:
	pass

## TODO: Build a settings menu that can be accessed from the main menu and the pause menu
func open_settings_main_menu() -> void:
	pass
#endregion

#region Pause Menu Actions
## Pause Menu -> HUD, 2D stays the same
func resume_game() -> void:
	get_tree().paused = false
	change_ui_scene(SceneMap.HUD, false, false)

func reset_game() -> void:
	print_debug("Resetting game")

func open_settings_pause_menu() -> void:
	pass
#endregion

func quit_game() -> void:
	get_tree().quit()

