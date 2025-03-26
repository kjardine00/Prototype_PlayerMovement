extends HBoxContainer

@export var coin_label: Label

func _ready() -> void:
	if coin_label:
		coin_label.text = str(Global.player_inventory.get_coin_count())
		# Connect to the coin collection signal to update the counter
		if Global.player_inventory:
			Global.player_inventory.update_coin_count_ui.connect(_update_coin_count)

func _update_coin_count() -> void:
	if coin_label:
		coin_label.text = str(Global.player_inventory.get_coin_count())

func _process(_delta: float) -> void:
	pass
