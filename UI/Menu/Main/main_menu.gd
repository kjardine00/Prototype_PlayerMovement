extends CenterContainer
class_name MainMenu

@onready var new_game: Button = $PanelContainer/VBoxContainer/NewGame


func _ready() -> void:
	new_game.grab_focus()

func _on_new_game_pressed() -> void:
	self.queue_free()
	Global.game_controller.change_2d_scene(Global.AREA_HUB, false, false)
	Global.game_controller.change_ui_scene(Global.HUD, false, false, false)

func _on_continue_pressed() -> void:
	pass # Replace with function body.


func _on_settings_pressed() -> void:
	print_debug("Settings") # Replace with function body.


func _on_quit_pressed() -> void:
	get_tree().quit()
