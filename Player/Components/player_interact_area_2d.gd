extends Area2D
class_name Player_Interaction_Area2D

var selected_interactable : InteractComponent
var nearby_interactables : Array[InteractComponent]
var player : Player

##  NOTE: This takes the possible interactable objects and puts them into an ordered array from 
## closest to the player to furthest and as the player leaves the interactable area of other obj
## that obj is removed from the array. When the player uses the interact input that object handles
## the input for interaction

func _ready():
	player = get_parent()

## The player interacts with the obj on press of the interact button
func interact(player_character: Player):
	if selected_interactable:
		selected_interactable.interaction_signal(player_character)

		if selected_interactable.remove_after_interact:
			# Temporarily store the reference
			var to_remove = selected_interactable

			# Disable interaction
			to_remove.set_deferred("monitoring", false)
			to_remove.set_deferred("monitorable", false)

			# Defer removal to avoid issues in the same frame
			await get_tree().process_frame

			# Now remove it and update selection
			nearby_interactables.erase(to_remove)
			if selected_interactable == to_remove:
				selected_interactable = null

			if nearby_interactables.size() > 0:
				selected_interactable = nearby_interactables[0]

func _on_area_entered(area: Area2D) -> void:
	if area is InteractComponent:
		nearby_interactables.push_back(area)
		area.can_interact.emit(true)

		if (selected_interactable  == null):
			selected_interactable = nearby_interactables[0]

func _on_area_exited(area: Area2D) -> void:
	if area is InteractComponent:
		nearby_interactables.erase(area)
		
		if selected_interactable:
			selected_interactable.stop_interacting(player)
			selected_interactable = null
		
		if (nearby_interactables.size() > 0):
			selected_interactable = nearby_interactables[0]
