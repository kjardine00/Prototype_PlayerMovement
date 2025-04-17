extends Node
class_name SceneMap
##============================ 2D =============================
const AREA_HUB = "res://World/HubArea/area_hub.tscn"
const PROTO_DUNGEON = "res://World/ProtoDungeon/proto_dungeon.tscn"

##============================ UI =============================
const HUD = "res://UI/HUD/hud.tscn"
const MAIN_MENU = "res://UI/Menu/Main/main_menu.tscn"
const PAUSE_MENU = "res://UI/Menu/Pause/pause_menu.tscn"

func _ready() -> void:
    Global.scene_map = self