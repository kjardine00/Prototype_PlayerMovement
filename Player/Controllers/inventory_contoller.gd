extends Node2D
class_name Inventory_Controller

#region Inventory Slots
@onready var active_item: Node2D = $ActiveItem
@onready var stowed_item: Node2D = $StowedItem
@onready var head_equip: Node2D = $HeadEquip
@onready var body_equip: Node2D = $BodyEquip
@onready var foot_equip: Node2D = $FootEquip
@onready var charm_equip: Node2D = $CharmEquip

var empty_active: bool = true
var empty_stowed: bool = true

var active_item_node
var stowed_item_node
#endregion

#region UI Elements
var active_icon
var stowed_icon
var head_icon
var body_icon
var foot_icon
var charm_icon
#endregion

var facing : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global.player_inventory = self

func _process(_delta: float) -> void:
	pass

func pickup(item):
	active_item_node = item
	empty_active = false
	active_icon = item.icon

func swap_active():
	if !empty_active && !empty_stowed:
		var temp_active = active_item.get_children()
		var temp_stowed = stowed_item.get_children()
		
		for i in temp_active:
			i.reparent(stowed_item)
		for i in temp_stowed:
			i.reparent(active_item)
		
		var temp_icon = active_icon
		active_icon = stowed_icon
		stowed_icon = temp_icon
		
		var temp_node = active_item_node
		active_item_node = stowed_item_node
		stowed_item_node = temp_node
	
	elif !empty_active && empty_stowed:
		var temp_active = active_item.get_children()
		
		for i in temp_active:
			i.reparent(stowed_item)
		
		stowed_icon = active_icon
		active_icon = null
		
		stowed_item_node = active_item_node
		active_item_node = null
		
		empty_active = !empty_active
		empty_stowed = !empty_stowed
		
	elif empty_active && !empty_stowed:
		var temp_stowed = stowed_item.get_children()
		
		for i in temp_stowed:
			i.reparent(active_item)
			
		active_icon = stowed_icon
		stowed_icon = null

		active_item_node = stowed_item_node
		stowed_item_node = null
		
		empty_active = !empty_active
		empty_stowed = !empty_stowed

func handle_throw_drop(last_input_dir):
	if active_item_node:
		active_item_node.throw_drop(last_input_dir)

		active_item_node = null
		active_icon = null
		empty_active = true
	
func handle_attack_input(last_input_dir):
	if active_item_node:
		active_item_node.attack(facing, last_input_dir)
