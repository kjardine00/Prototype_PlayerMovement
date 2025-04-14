extends MarginContainer

signal finished_displaying_text

@export var dialog_label: Label
@export var timer: Timer

@export var amount_to_offset_above_character: int = 50

const MAX_WIDTH = 1000
const MAX_HEIGHT = 1000

var text: String = ""
var letter_index: int = 0

var letter_timer: float = 0.03
var space_timer: float = 0.06
var punctuation_timer: float = 0.02

func display_text(text_to_display: String) -> void:
	text = text_to_display
	dialog_label.text = text

	await resized

	custom_minimum_size.x = min(size.x, MAX_WIDTH)

	if size.x > MAX_WIDTH:
		dialog_label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized # wait for the x resize
		await resized # wait for the y resize
		custom_minimum_size.y = size.y

	global_position.x -= size.x / 2
	global_position.y -= size.y / 2 + amount_to_offset_above_character

	dialog_label.text = ""
	_display_letter()

func _display_letter() -> void:
	dialog_label.text += text[letter_index]
	letter_index += 1

	if letter_index >= text.length():
		finished_displaying_text.emit()
		return 

	match text[letter_index]:
		"!", ".", "?", ",":
			timer.start(punctuation_timer)
		" ":
			timer.start(space_timer)
		_:
			timer.start(letter_timer)
	

func _on_letter_display_timer_timeout() -> void:
	_display_letter()
