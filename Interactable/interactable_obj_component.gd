extends Area2D
class_name InteractComponent

signal interact
signal stop_interact

# the player hits the interaction button, tell the obj that the player is interacting
func interaction_signal(interactor: CharacterBody2D):
	interact.emit(interactor)

# the player has left the interaction area, exit functionality
func stop_interacting(interactor: CharacterBody2D):
	stop_interact.emit()
	#printerr("Nothing should trigger rn")
	pass
