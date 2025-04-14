extends Area2D
class_name AreaTransition

@export_category("Connections")
@export var interact_component: InteractComponent
@export var interact_icon: Sprite2D

@export var to_area_path: String

func _ready() -> void:
	interact_component.interact.connect(on_interact)
	interact_component.toggle_interact_icon.connect(interact_toggle)
	interact_icon.visible = false

func on_interact(_player: Player) -> void:
	print_debug("Player interacted with dungeon entrance")
	if to_area_path != "":
		Global.game_controller.change_2d_scene(to_area_path)

func interact_toggle(can_interact: bool = false) -> void:
	if can_interact:
		interact_icon.visible = true
	else:
		interact_icon.visible = false