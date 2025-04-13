extends Node2D
class_name RoomGenerator

@export var debug: bool = true

@onready var generated_rooms: Node2D = $GeneratedRooms

const ROOM_SIZE := Vector2i(43, 27) # 43 tiles wide, 27 tiles tall
@onready var room_size = Global.tile_size * ROOM_SIZE
var borders := Rect2i(0, 0, 5, 5)
var start_coord = Vector2i(2, 0)
var total_rooms: int = 15

var room_grid : Array[Vector2i] = []

@export_category("Properties")
@export_group("Connections")
@export var START_ROOM: PackedScene
@export var NORMAL_ROOMS: Array[PackedScene]
@export var EMPTY_ROOMS: PackedScene

func _ready() -> void:	
	var WALKER = Walker.new(start_coord, borders)
	room_grid = WALKER.generate_grid(total_rooms)
	if debug:
		console_grid(room_grid)
	WALKER.call_deferred("queue_free")

func place_rooms():
	if START_ROOM:
		var inst = START_ROOM.instantiate()
		generated_rooms.call_deferred("add_child", inst)
		inst.position = start_coord * room_size
		room_grid.erase(start_coord)

	for room_coord in room_grid:
		if NORMAL_ROOMS.size() != 0:
			var inst = NORMAL_ROOMS.pick_random().instantiate()
			generated_rooms.call_deferred("add_child", inst)
			inst.position = room_coord * room_size
		else:
			push_error("NO NORMAL ROOMS FOUND")
			return
			
	# Place rooms in empty spaces within borders
	for y in range(borders.position.y, borders.position.y + borders.size.y):
		for x in range(borders.position.x, borders.position.x + borders.size.x):
			var coord = Vector2i(x, y)
			if not room_grid.has(coord) or coord == start_coord:
				if EMPTY_ROOMS:
					var inst = EMPTY_ROOMS.instantiate()
					generated_rooms.call_deferred("add_child", inst)
					inst.position = coord * room_size
	

#region Debug Methods
func console_grid(grid: Array[Vector2i]):
	# Print grid row by row using borders dimensions
	print("Grid:")
	for y in range(borders.position.y, borders.position.y + borders.size.y):
		var row = "[ "
		for x in range(borders.position.x, borders.position.x + borders.size.x):
			if grid.has(Vector2i(x, y)):
				row += "X"
			else:
				row += "O"
			if x < borders.position.x + borders.size.x - 1:
				row += " , "
		row += " ]"
		print(row)
#endregion
