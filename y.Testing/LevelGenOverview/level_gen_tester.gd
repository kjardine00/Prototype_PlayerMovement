extends Node2D

@onready var camera_2d: Camera2D = $Camera2D
@export var room_generator: RoomGenerator

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	room_generator.place_rooms()
	var cam_pos = Vector2i(2, 2) * room_generator.room_size
	camera_2d.global_position = cam_pos

func _on_button_pressed() -> void:
	get_tree().reload_current_scene()
