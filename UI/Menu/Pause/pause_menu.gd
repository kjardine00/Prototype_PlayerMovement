extends CenterContainer
class_name PauseMenu

@export var resume: Button

func _ready() -> void:
	if resume:
		resume.grab_focus()

func _on_resume_pressed() -> void:
	Global.game_controller.resume_game()

func _on_reset_pressed() -> void:
	Global.game_controller.reset_game()

func _on_settings_pressed() -> void:
	pass # Replace with function body.

func _on_quit_pressed() -> void:
	get_tree().quit()
