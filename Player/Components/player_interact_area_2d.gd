extends Area2D
class_name Player_Interaction_Area2D

var selected_interactable : InteractComponent
var nearby_interactables : Array[InteractComponent]
var player : Player

func _ready():
	player = get_parent()

## The player interacts with the obj on press of the interact button
func interact(player):
	#print(str(selected_interactable))
	if selected_interactable:
		selected_interactable.interaction_signal(player)
	
func _on_area_entered(area: Area2D) -> void:
	if area is InteractComponent:
		nearby_interactables.push_back(area)
		
		if (selected_interactable  == null):
			selected_interactable = nearby_interactables[0]

func _on_area_exited(area: Area2D) -> void:
	if area is InteractComponent:
		nearby_interactables.erase(area)
		
		selected_interactable.stop_interacting(player)
		selected_interactable = null
		
		if (nearby_interactables.size() > 0):
			selected_interactable = nearby_interactables[0]
