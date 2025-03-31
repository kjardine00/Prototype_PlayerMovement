extends Sprite2D

@export var interact_component: InteractComponent
@export var interaction_icon: Sprite2D

const lines: Array[String] = [
	"Hello, world!",
	"This is a test.",
	"This is another test.",
	"This is the last test."
]

func _ready() -> void:
	interact_component.interact.connect(player_is_interacting)
	interact_component.can_interact.connect(interact_toggle)
	interaction_icon.visible = false

func interact_toggle(can_interact: bool = false) -> void:
	if can_interact:
		interaction_icon.visible = true
	else:
		interaction_icon.visible = false

func player_is_interacting(_player: Player) -> void:
	DialogManager.handle_interact(lines, self.global_position)
