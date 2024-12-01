extends Area2D
class_name ClimbableObj

func _ready() -> void:
	self.body_entered.connect(_on_body_entered)
	self.body_exited.connect(_on_body_exited)

func _on_body_entered(body) -> void:
	body.CAN_CLIMB = true

func _on_body_exited(body) -> void:
	body.CAN_CLIMB = false
