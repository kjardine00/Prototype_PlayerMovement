extends Throwable_obj
class_name Box_Obj

func _ready() -> void:
	super()

func _physics_process(delta: float) -> void:
	super(delta)

func _interact(interactor: Player):
	match state:
		states.IDLE:
			_pick_up(interactor)
		states.PICKED_UP:
			pass
		states.THROWN:
			pass
	
func damage():
	pass 
	
