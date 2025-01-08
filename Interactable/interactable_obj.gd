extends Node
#class_name Interactable_Obj

@export_category("Connections")
#@export var interact_component : InteractComponent

#func _ready() -> void:
	#interact_component.interact.connect(_interaction_signal)
	#interact_component.stop_interact.connect(_stop_interacting_signal)

func _interaction_signal(interactor: Player):
	##This is where when the player clicks to interact the obj does stuff
	interact(interactor)
	
	
func _stop_interacting_signal(interactor: Player):
	stop_interact(interactor)

func interact(interactor):
	print("interacting with " + str(interactor))
	pass

func stop_interact(interactor):
	print("stop interact with " + str(interactor))
	pass
	
