extends Node
class_name GameController

@export var world_2d: Node2D
@export var ui: Control
@export var transition_controller: SceneTransitionController

const SCENES_2D = {
	"AREA_HUB": "res://World/HubArea/area_hub.tscn",
	"PROTO_DUNGEON": "res://World/ProtoDungeon/proto_dungeon.tscn"
}

const SCENES_UI = {
	"HUD": "res://UI/HUD/hud.tscn",
	"MAIN_MENU": "res://UI/Menu/main_menu.tscn", 
	"PAUSE_MENU": "res://UI/Menu/pause_menu.tscn",
}

var current_2d_scene : Node
var current_ui_scene : Node

func _ready() -> void:
	Global.game_controller = self
	change_ui_scene(Global.MAIN_MENU, false, false, false)

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
	keep_running: bool = false,
	transition: bool = true,
	# transition_in : String = "Fade In", 
	# transition_out : String = "Fade Out", 
	# seconds: float = 1.0
	):

	# if transition:
	# 	transition_controller.transition(transition_out, seconds)
	# 	await transition_controller.animation_player.animation_finished
	if current_ui_scene:
		if new_scene in ui.get_children():
			new_scene.visible = true
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

func open_inventory() -> void:
	pass

func close_inventory() -> void:
	pass

func pause_game() -> void:
	get_tree().paused = true
	change_ui_scene(Global.PAUSE_MENU, false, true, false)

func resume_game(current_scene: Node = current_ui_scene) -> void:
	get_tree().paused = false
	change_ui_scene(Global.HUD, false, true, false)

func open_settings() -> void:
	pass

func close_settings() -> void:
	pass


#endregion

func reset_game() -> void:
	print_debug("Resetting game")
	# change_2d_scene(Global.AREA_HUB, false, false)
	# change_ui_scene(Global.HUD, false, false, false)
	pass
