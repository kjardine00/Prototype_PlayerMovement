extends Node
class_name Walker

const DIRECTIONS = [Vector2.RIGHT, Vector2.UP, Vector2.LEFT, Vector2.DOWN]

@export_category("Properties")
@export var MAX_HALLWAY_LENGTH : int

var position = Vector2.ZERO
var target_pos = Vector2.ZERO
var step_history = []
var borders = Rect2()
var direction = Vector2.DOWN
var steps_since_turn = 0

func _init(starting_position, given_borders) -> void:
	assert(given_borders.has_point(starting_position))
	position = starting_position
	step_history.append(position)
	
	borders = given_borders
	direction = DIRECTIONS[randi() % 4]
	
func walk(steps):
	var step_count = 0
	while step_count < (steps -1):
		
		var MAX_HALLWAY_LENGTH = ceil(steps / 3.0)
		
		if MAX_HALLWAY_LENGTH < 4:
			MAX_HALLWAY_LENGTH = 4
	
		if steps_since_turn >= 2:
			change_direction()
			
		if step():
			# If the walker has already been to this position
			if step_history.has(target_pos) == true:
				position = target_pos
				change_direction()
				continue
			var neighbours = ncount(target_pos)
			
			# If this step has neighbors greater than 1
			if neighbours > 1:
				change_direction()
				continue
				
			# Randomize direction change
			if randf() < 0.5:
				change_direction()
				continue
			
			# Check how long the steps has moved in the same direction
			if get_hallway_length(target_pos) > MAX_HALLWAY_LENGTH:
				change_direction()
				continue
			
			# Set current potential step to the position we will save
			position = target_pos
			
			# Save position in history
			step_history.append(position)
			step_count += 1
		else:
			change_direction()
	
	return step_history
	
# Check all the rooms in the room history and return the rooms that dont have neighboors thus being an end room
func get_end_rooms():
	var end_rooms = []
	for step_position in step_history:
		if ncount(step_position) == 1:
			end_rooms.append(step_position)
			
	return end_rooms

func step() -> bool:
	target_pos = position + direction
	if borders.has_point(target_pos):
		steps_since_turn += 1
		return true
	else: 
		return false

func change_direction():
	steps_since_turn = 0
	var directions = DIRECTIONS.duplicate()
	direction.shuffle()
	direction = direction.pop_front()
	while not borders.has_point(position + direction):
		direction = directions.pop_front()

func ncount(pos):
	return int(step_history.has(pos + Vector2.LEFT)) \
	+ int(step_history.has(pos + Vector2.UP)) \
	+ int(step_history.has(pos + Vector2.RIGHT)) \
	+ int(step_history.has(pos + Vector2.DOWN))

func get_hallway_length(pos):
	var longest_hallway = 0
	var hallway_length = 0
	
	# Check right hallway
	hallway_length = calc_hallway_length(pos, Vector2.RIGHT)
	longest_hallway = get_longest_hallway(longest_hallway, hallway_length)
	# Check left hallway
	hallway_length = calc_hallway_length(pos, Vector2.LEFT)
	longest_hallway = get_longest_hallway(longest_hallway, hallway_length)
	# Check up hallway
	hallway_length = calc_hallway_length(pos, Vector2.UP)
	longest_hallway = get_longest_hallway(longest_hallway, hallway_length)
	# Check down hallway
	hallway_length = calc_hallway_length(pos, Vector2.DOWN)
	longest_hallway = get_longest_hallway(longest_hallway, hallway_length)
	
	return longest_hallway

# Take the position of a room and look through step history to see how far a hallway is in every direction
func calc_hallway_length(start_room, hallway_direction):
	var hallway_length = 1
	while(step_history.has(start_room + hallway_direction)):
		start_room += hallway_direction
		hallway_length += 1
	return hallway_length
	
func get_longest_hallway(longest_hallway, current_hallway_length):
	if current_hallway_length > longest_hallway:
		return current_hallway_length
	else:
		return longest_hallway
