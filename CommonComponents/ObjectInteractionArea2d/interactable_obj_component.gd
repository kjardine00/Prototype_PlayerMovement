extends Area2D
class_name InteractComponent

signal interact
signal stop_interact
signal toggle_interact_icon

var remove_after_interact : bool = false

## NOTE: This handles when the player gives the interact input or leaves the interaction area
## If the player gives the interact input then that input is sent to the obj's script to handle that input

# the player hits the interaction button, tell the obj that the player is interacting
func interaction_signal(interactor: CharacterBody2D):
	interact.emit(interactor)
	toggle_interact_icon.emit(false)

# the player has left the interaction area, exit functionality
func stop_interacting(_interactor: CharacterBody2D):
	stop_interact.emit()
	toggle_interact_icon.emit(false)
	
func toggle_area2d_monitoring():
	if monitoring:
		monitoring = false
	else:
		monitoring = true

## TODO: Create a function that disables the area2d and refactor all the objects that do that in their own scripts
func disable_area2d():
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)
