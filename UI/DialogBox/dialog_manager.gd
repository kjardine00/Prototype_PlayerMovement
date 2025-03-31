extends Node

@onready var dialog_box = preload("res://UI/DialogBox/dialog_box.tscn")

var dialog_lines: Array[String] = []
var current_line_index: int = 0

var text_box
var text_box_position: Vector2

var is_dialog_active: bool = false
var can_advance_line = false

func handle_interact(lines: Array[String], position: Vector2) -> void:
    if is_dialog_active:
        continue_dialog()
    else:
        start_dialog(lines, position)

func start_dialog(lines: Array[String], position: Vector2) -> void:
    if is_dialog_active:
        return

    dialog_lines = lines
    text_box_position = position
    _show_dialog_box()
    
    is_dialog_active = true
    current_line_index = 0

func _show_dialog_box() -> void:
    text_box = dialog_box.instantiate()
    text_box.finished_displaying_text.connect(_on_dialog_box_finished_displaying_text)
    get_tree().current_scene.add_child(text_box)
    text_box.global_position = text_box_position
    text_box.display_text(dialog_lines[current_line_index])

    can_advance_line = false

func _on_dialog_box_finished_displaying_text() -> void:
    can_advance_line = true

func continue_dialog():
    if is_dialog_active and can_advance_line:
        text_box.queue_free()

        current_line_index += 1

        if current_line_index >= dialog_lines.size():
            is_dialog_active = false
            current_line_index = 0
            return
        
        _show_dialog_box()