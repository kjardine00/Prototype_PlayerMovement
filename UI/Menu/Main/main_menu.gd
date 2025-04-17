extends CenterContainer
class_name MainMenu

@export var new_game: Button

func _ready() -> void:
	new_game.grab_focus()

func _on_new_game_pressed() -> void:
	Global.game_controller.new_game()

func _on_continue_pressed() -> void:
	Global.game_controller.continue_game()

func _on_settings_pressed() -> void:
	Global.game_controller.open_settings()

func _on_quit_pressed() -> void:
	get_tree().quit()
