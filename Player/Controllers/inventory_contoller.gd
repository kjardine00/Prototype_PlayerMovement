extends Node2D
class_name Inventory_Controller

#region Inventory Slots
@onready var active_item_node: Node2D = $ActiveItem
@onready var stowed_item_node: Node2D = $StowedItem
@onready var head_equip_node: Node2D = $HeadEquip
@onready var body_equip_node: Node2D = $BodyEquip
@onready var foot_equip_node: Node2D = $FootEquip
@onready var charm_equip_node: Node2D = $CharmEquip

var empty_active: bool = true
var empty_stowed: bool = true

var active_item
var stowed_item
var head_equip
var body_equip
var foot_equip
var charm_equip
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

#region Inventory Node Setters
func set_active(item):
	active_item = item
	if item == null:
		active_icon = null
	else:
		active_icon = item.icon

func set_stowed(item):
	stowed_item = item
	if item == null:
		stowed_icon = null
	else:
		stowed_icon = item.icon

func set_head_equip(item):
	head_equip = item
	if item == null:
		stowed_icon = null
	else:
		head_icon = item.icon

func set_body_equip(item):
	body_equip = item
	if item == null:
		body_icon = null
	else:
		body_icon = item.icon
	
func set_foot_equip(item):
	foot_equip = item
	if item == null:
		foot_icon = null
	else:
		foot_icon = item.icon
	
func set_charm_equip(item):
	charm_equip = item
	if item == null:
		charm_icon = null
	else:
		charm_icon = item.icon
#endregion

func swap_active():
	if active_item && stowed_item:
		var temp_active = active_item
		var temp_stowed = stowed_item
		
		temp_active.reparent(stowed_item_node)
		temp_stowed.reparent(active_item_node)
		
		set_active(temp_stowed)
		set_stowed(temp_active)

	elif active_item && !stowed_item:
		var temp_active = active_item
		
		temp_active.reparent(stowed_item_node)
		
		set_active(null)
		set_stowed(temp_active)
		
	elif !active_item && stowed_item:
		var temp_stowed = stowed_item
		
		temp_stowed.reparent(active_item_node)
		
		set_active(temp_stowed)
		set_stowed(null)
#region Active & Stowed Actions
func handle_throw_drop(last_input_dir):
	if active_item:
		active_item.throw_drop(last_input_dir)
		set_active(null)
	
func handle_attack_input(last_input_dir):
	#TODO Add a cooldown to prevent spamming bugs
	if active_item:
		active_item.attack(facing, last_input_dir)
#endregion

#region Handle Equipment Actions
func handle_ability_input():
	if body_equip:
		body_equip.ability()

#endregion
