extends Node
class_name State

var state_machine: State_Machine
var player : Player 

func enter_state():
	pass
	
func exit_state():
	pass
	
func update(delta: float):
	pass
	
func handle_animation(anim_name : String):
	state_machine.player_character.anim_controller.play_anim(anim_name)

func handle_idle():
	pass
