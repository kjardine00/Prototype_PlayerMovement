extends Camera2D


func _input(event: InputEvent) -> void:
	if event.get_action_strength("mouse_up"):
		zoom = clamp(zoom + Vector2.ONE * 0.01 ,Vector2.ONE * 0.01,Vector2.ONE * 5.0)
	
	if event.get_action_strength("mouse_down"):
		zoom = clamp(zoom - Vector2.ONE * 0.01 ,Vector2.ONE * 0.01,Vector2.ONE * 5.0)
	
	## Click and drag
	if event is InputEventMouseMotion and Input.is_action_pressed("mouse_drag"):
		global_position -= event.relative / zoom
