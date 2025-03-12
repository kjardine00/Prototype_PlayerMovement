extends Throwable_obj

func _ready() -> void:
	super()

func _physics_process(delta: float) -> void:
	super(delta)

func _interact(interactor: Player):
	match state:
		states.IDLE:
			_pick_up(interactor)
			state = states.PICKED_UP
		states.PICKED_UP:
			pass
		states.THROWN:
			pass

func attack():
	print_debug("Weapon Attack")
	
func damage():
	pass
