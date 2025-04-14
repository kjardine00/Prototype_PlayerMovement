extends Sprite2D

@export var interact_component: InteractComponent
@export var interaction_icon: Sprite2D
@export var sign_text: Array[String]

const lines: Array[String] = [
	"Hello, world!",
	"Missing Text",
	"Missing Text",
	"Missing Text"
]

func _ready() -> void:
	interact_component.interact.connect(player_is_interacting)
	interact_component.stop_interact.connect(stop_interacting)
	interact_component.toggle_interact_icon.connect(interact_toggle)
	interaction_icon.visible = false

func interact_toggle(can_interact: bool = false) -> void:
	if can_interact:
		interaction_icon.visible = true
	else:
		interaction_icon.visible = false

func player_is_interacting(_player: Player) -> void:
	if sign_text.size() < 1:
		sign_text = lines
	DialogManager.handle_interact(sign_text, self.global_position)

func stop_interacting() -> void:
	interact_toggle(false)
	if DialogManager.is_dialog_active:
		DialogManager.close_dialog()
