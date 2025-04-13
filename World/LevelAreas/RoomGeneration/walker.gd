extends Node
class_name Walker

const DIRECTIONS = [Vector2i.RIGHT, Vector2i.UP, Vector2i.LEFT, Vector2i.DOWN]

var grid : Array[Vector2i] = []
var grid_area : Rect2i # The allowed area for the walker to move in
var current_position : Vector2i # The position of the walker
var target_position : Vector2i # Where the walker is looking
var target_direction : Vector2i = DIRECTIONS[randi() % 4] # The direction the walker is looking

var steps_since_direction_change = 0

func _init(starting_position, area_size) -> void:
	current_position = starting_position
	grid_area = area_size
	assert(grid_area.has_point(current_position))

	grid.append(current_position)
	target_position = current_position + target_direction

func generate_grid(num_of_coords: int) -> Array[Vector2i]:
	var step_count = 0

	while step_count < (num_of_coords -1): # -1 because init with a step as the starting position
		target_position = current_position + target_direction
		if valid_step(current_position, target_position):
			grid.append(target_position)
			current_position = target_position
			step_count += 1
			steps_since_direction_change += 1
			
			if steps_since_direction_change >= 2:
				change_direction()
		else:
			change_direction()
	return grid
		
func valid_step(from_position, to_position) -> bool:
	assert(from_position != to_position)
	if grid.has(to_position): ## If the target position is already in the grid, return false
		return false
	
	elif not grid_area.has_point(to_position): ## If the target position is outside the grid border, return false
			return false
	
	else:
		return true

func change_direction():
	steps_since_direction_change = 0
	var possible_directions = DIRECTIONS.duplicate()
	possible_directions.shuffle()
	target_direction = possible_directions.pop_front()
	if not grid_area.has_point(target_position):
		target_direction = possible_directions.pop_front()

func get_end_rooms():
	var end_rooms = []
	for coordinate in grid:
		if ncount(coordinate) == 1:
			end_rooms.append(coordinate)
			
	return end_rooms

func ncount(pos): ## Neighbor Count
	return int(grid.has(pos + Vector2i.LEFT)) \
	+ int(grid.has(pos + Vector2i.UP)) \
	+ int(grid.has(pos + Vector2i.RIGHT)) \
	+ int(grid.has(pos + Vector2i.DOWN))

# func get_hallway_length(pos):
# 	var longest_hallway = 0
# 	var hallway_length = 0
	
# 	# Check right hallway
# 	hallway_length = calc_hallway_length(pos, Vector2.RIGHT)
# 	longest_hallway = get_longest_hallway(longest_hallway, hallway_length)
# 	# Check left hallway
# 	hallway_length = calc_hallway_length(pos, Vector2.LEFT)
# 	longest_hallway = get_longest_hallway(longest_hallway, hallway_length)
# 	# Check up hallway
# 	hallway_length = calc_hallway_length(pos, Vector2.UP)
# 	longest_hallway = get_longest_hallway(longest_hallway, hallway_length)
# 	# Check down hallway
# 	hallway_length = calc_hallway_length(pos, Vector2.DOWN)
# 	longest_hallway = get_longest_hallway(longest_hallway, hallway_length)
	
# 	return longest_hallway

# # Take the position of a room and look through step history to see how far a hallway is in every direction
# func calc_hallway_length(start_room, hallway_direction):
# 	var hallway_length = 1
# 	while(step_history.has(start_room + hallway_direction)):
# 		start_room += hallway_direction
# 		hallway_length += 1
# 	return hallway_length
	
# func get_longest_hallway(longest_hallway, current_hallway_length):
# 	if current_hallway_length > longest_hallway:
# 		return current_hallway_length
# 	else:
# 		return longest_hallway
