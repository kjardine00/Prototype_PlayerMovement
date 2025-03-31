extends Node2D
class_name LevelGen

@onready var generated_rooms: Node2D = $GeneratedRooms
@onready var player: Node2D = $Player

var rooms = []
var rooms_positions = []
var end_rooms = []

var room_size := Vector2(656, 384)
var borders := Rect2(1, 1, 9, 9)

@export_category("Properties")
@export var starting_room_pos = Vector2()

@export_group("Connections")
@export var PLAYER: PackedScene
@export var START_ROOM: PackedScene
@export var TREASURE_ROOMS: Array[PackedScene]
@export var BOSS_ROOMS: Array[PackedScene]
@export var NORMAL_ROOMS: Array[PackedScene]

@export_group("Number of Rooms")
@export var total_rooms: int = 30
@export var treasure_rooms: int
@export var secret_rooms: int
@export var boss_rooms: int

func _ready() -> void:
	call_deferred("generate_rooms")
	
	# Gets the correct size of the rooms
	if NORMAL_ROOMS.size() != 0:
		var inst = NORMAL_ROOMS[0].instantiate()
		for i in inst.get_children():
			if i is TileMapLayer:
				room_size = i.get_used_rect().size * i.tile_set.tile_size
		inst.queue_free()
	else:
		printerr("NO NORMAL ROOMS FOUND")

func generate_rooms():
	var random = RandomNumberGenerator.new()
	random.randomize()
	
	total_rooms = randi_range(total_rooms / 1.1, total_rooms * 1.2)
	print(str(total_rooms))
	
	var min_num_dead_ends = ceil(total_rooms / 3.0) + 1
	
	## TODO Adjust this value to match better what the generation should look like
	if min_num_dead_ends > 15:
		min_num_dead_ends = 15
		
	var gen_attempts = 0 
	while end_rooms.size() < min_num_dead_ends or end_rooms.has(starting_room_pos):
		gen_attempts += 1
		rooms.clear()
		end_rooms.clear()
		var WALKER = Walker.new(starting_room_pos, borders)
		rooms = WALKER.walk(total_rooms)
		end_rooms = WALKER.get_end_rooms()
		WALKER.call_deferred("queue_free")
	
	print("NEW GENERATION ATTEMPT TOOK " + str(gen_attempts) + " ATTEMPTS")
	rooms_positions = rooms.duplicate()
	
	if START_ROOM:
		place_start_room()
	else:
		printerr("NO STARTING ROOM FOUND")
	
	## TODO Place Boss Rooms
	if BOSS_ROOMS:
		place_boss_rooms()
	else:
		printerr("NO BOSS ROOMS FOUND")
		
	## TODO Place Treasure Rooms
	if TREASURE_ROOMS:
		place_treasure_rooms()
	else:
		printerr("NO TREASURE ROOMS FOUND")
	
	## TODO Place Irregular Rooms
	## TODO Place Secret Rooms
	
	if NORMAL_ROOMS.size() != 0:
		place_normal_rooms()
	else:
		printerr("NO NORMAL ROOMS FOUND")

#region Place Room Methods

func place_start_room():
	var inst = START_ROOM.instantiate()
	generated_rooms.call_deferred("add_child", inst)
	
	inst.position = starting_room_pos * room_size
	rooms.erase(starting_room_pos)
	
	## TODO Create Doors here so that if there isn't a room adjacent the player can't go that direction
	dadad
func place_normal_rooms():
	for location in rooms: 
		var inst = NORMAL_ROOMS.pick_random().instantiate()
		generated_rooms.call_deferred("add_child", inst)
		inst.position = location * room_size
		#TODO FIGURE OUT ROOMS with doors that could lead nowhere

func place_treasure_rooms():
	pass
	
func place_boss_rooms():
	pass

#endregion
