extends Node

const TILE_SIZE : int = 32

#region Scenes
const AREA_HUB = "res://World/HubArea/area_hub.tscn"
const PROTO_DUNGEON = "res://World/ProtoDungeon/proto_dungeon.tscn"
#endregion

#region UI
const MAIN_MENU = "res://UI/Menu/main_menu.tscn"
const HUD = "res://UI/HUD/hud.tscn"
const PAUSE_MENU = "res://UI/Menu/pause_menu.tscn"
#endregion


var game_controller : GameController
var player_inventory : Inventory_Controller

