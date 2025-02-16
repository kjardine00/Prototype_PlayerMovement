extends Resource
class_name InvItem

@export var name: String = ""
@export var texture: Texture2D
@export var sprite_sheet: Texture2D
@export var sprite_frames: int

##If the item can be held in the player's active item slot
@export var can_hold: bool
##If the item can be stowed in the player's inactive item slot
@export var can_stow: bool
