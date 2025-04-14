extends MarginContainer

signal finished_displaying_text

@export var dialog_label: RichTextLabel
@export var timer: Timer

@export var amount_to_offset_above_character: int = 50

const MAX_WIDTH = 1000
const MAX_HEIGHT = 1000

const UI_attack_texture = "res://Assets/UIActionPrompts/UI_attack.tres"
const UI_interact_texture = "res://Assets/UIActionPrompts/UI_interact.tres"
const UI_swap_active_texture = "res://Assets/UIActionPrompts/UI_swap_active.tres"
const UI_throw_drop_texture = "res://Assets/UIActionPrompts/UI_throw_drop.tres"
const UI_use_ability_texture = "res://Assets/UIActionPrompts/UI_throw_drop.tres"
const UI_use_charm_texture = "res://Assets/UIActionPrompts/UI_use_charm.tres"

var text: String = ""
var letter_index: int = 0
var is_parsing_text: bool = false
var current_parsed_text: String = ""
var display_text_array: Array[String] = []

var letter_timer: float = 0.03
var space_timer: float = 0.06
var punctuation_timer: float = 0.02

var ui_textures: Dictionary = {}

func _ready() -> void:
	# Pre-load UI textures
	ui_textures["%UI_attack%"] = UI_attack_texture
	ui_textures["%UI_interact%"] = UI_interact_texture
	ui_textures["%UI_swap_active%"] = UI_swap_active_texture
	ui_textures["%UI_throw_drop%"] = UI_throw_drop_texture
	ui_textures["%UI_use_ability%"] = UI_use_ability_texture
	ui_textures["%UI_use_charm%"] = UI_use_charm_texture

func display_text(text_to_display: String) -> void:
	text = text_to_display
	display_text_array.clear()
	
	# Pre-calculate the full text with UI textures replaced and build display array
	var full_text = ""
	var i = 0
	while i < text.length():
		if text[i] == "%":
			var start = i
			i += 1
			while i < text.length() and text[i] != "%":
				i += 1
			if i < text.length():
				var key = text.substr(start, i - start + 1)
				if key in ui_textures:
					# Add the rich text element as a single unit
					display_text_array.append("[img=14]" + ui_textures[key] + "[/img]")
					full_text += "[img=14]" + ui_textures[key] + "[/img]"
				else:
					display_text_array.append(key)
					full_text += key
				i += 1
			else:
				display_text_array.append(text.substr(start))
				full_text += text.substr(start)
		else:
			display_text_array.append(text[i])
			full_text += text[i]
			i += 1
	
	# Set the full text to calculate size
	dialog_label.text = full_text
	await resized
	
	custom_minimum_size.x = min(size.x, MAX_WIDTH)
	
	if size.x > MAX_WIDTH:
		dialog_label.autowrap_mode = TextServer.AUTOWRAP_WORD
		await resized
		custom_minimum_size.y = size.y
	
	global_position.x -= size.x / 2
	global_position.y -= size.y / 2 + amount_to_offset_above_character
	
	# Clear and start displaying
	dialog_label.text = ""
	letter_index = 0
	_display_letter()

func _display_letter() -> void:
	if letter_index >= display_text_array.size():
		finished_displaying_text.emit()
		return

	var current_element = display_text_array[letter_index]
	
	# Add the current element to the display
	if current_element == "  ":  # This is a UI texture placeholder
		var key = text.substr(text.find("%", letter_index), text.find("%", letter_index + 1) - text.find("%", letter_index) + 1)
		dialog_label.text += "[img=14]" + ui_textures[key] + "[/img]"
	else:
		dialog_label.text += current_element
	
	# Set timer for next element
	if letter_index + 1 < display_text_array.size():
		var next_element = display_text_array[letter_index + 1]
		if next_element == "  ":  # UI texture placeholder
			timer.start(letter_timer * 2)
		elif next_element == " ":
			timer.start(space_timer)
		elif next_element in ["!", ".", "?", ","]:
			timer.start(punctuation_timer)
		else:
			timer.start(letter_timer)

	letter_index += 1

	if letter_index >= display_text_array.size():
		finished_displaying_text.emit()
		return

func _on_letter_display_timer_timeout() -> void:
	_display_letter()
