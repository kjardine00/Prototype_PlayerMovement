extends Node2D

@onready var camera_2d: Camera2D = $Camera2D
@export var level_generator: LevelGen
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	level_generator.generate_rooms()
	var cam_pos = level_generator.starting_room_pos * level_generator.room_size
	camera_2d.global_position = cam_pos

func _on_button_pressed() -> void:
	get_tree().reload_current_scene()
