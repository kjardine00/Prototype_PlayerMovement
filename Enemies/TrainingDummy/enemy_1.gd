extends CharacterBody2D
class_name Enemy

@export_category("Connections")
@export var health_comp : HealthComp
@onready var label: Label = $CenterContainer/VBoxContainer/Label
@onready var label_2: Label = $CenterContainer/VBoxContainer/Label2

@export_group("Gravity")
@export_range(0, 100) var gravity_str: float = 18
@export_range(0.5, 3) var desc_gravity_factor: float = 2.3
@export_range(600, 1200) var terminal_velocity = 1000
@export var gravity_active : bool = false

var applied_gravity: float
var applied_terminal_vel: float

func _ready() -> void:
	gravity_active = true
	health_comp.damage_taken.connect(_damage_taken)
	
func _physics_process(_delta: float) -> void:
	_gravity()
	move_and_slide()

func _gravity():
	if velocity.y > 0:
		applied_gravity = gravity_str * desc_gravity_factor
	else: 
		applied_gravity = gravity_str

	if gravity_active:
		if velocity.y < terminal_velocity:
			velocity.y += applied_gravity
		elif velocity.y > terminal_velocity:
			velocity.y = terminal_velocity
			
func _damage_taken(damage, damage_type):
	label.text = str(damage)
	label_2.text = str(damage_type)
	await get_tree().create_timer(1).timeout
	label.text = ""
	label_2.text = ""
