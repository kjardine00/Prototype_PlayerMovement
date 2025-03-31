extends Node2D
class_name DungeonEntrance

@export var interact_component: InteractComponent
@export var interact_icon: Sprite2D

const DUNGEON_SCENE: String = "res://World/Dungeon/RoomGenerator/level_generator.tscn"

func _ready() -> void:
	interact_component.interact.connect(on_interact)
	interact_component.can_interact.connect(interact_toggle)
	interact_icon.visible = false

func on_interact(_player: Player) -> void:
	print_debug("Player interacted with dungeon entrance")
	# Global.game_controller.change_2d_scene(DUNGEON_SCENE)

func interact_toggle(can_interact: bool = false) -> void:
	if can_interact:
		interact_icon.visible = true
	else:
		interact_icon.visible = false
