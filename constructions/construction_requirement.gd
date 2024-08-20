class_name ConstructionRequirement extends TileMapLayer

enum Operations { ALL, NONE, MORE_THAN, LESS_THAN, EXACTLY }
@export var operation: = Operations.ALL

# See terrain.gd. This really should match.
#@export_flags("None", "Grass", "RoadDirt", "River", "Cliff", "Trees") var terrain: = 0
#var _flag_keys: = {
	#1: "None",
	#2: "Grass",
	#4: "RoadDirt",
	#8: "River",
	#16: "Cliff",
	#32: "Trees"
#}
@export var terrain: Array[String]
@export var terrain_quantity: = 0

# Look for a number of constructions. If multiple are provided, it is an "or" relationship.
@export var construction_types: Array[ConstructionData]
@export var construction_quantity: = 0


func validate_requirement(target_cell:Vector2i, get_occupants: Callable, 
		get_terrain_at_cells: Callable) -> bool:
	# Offset all cells by the target cell:
	var checked_cells: Array[Vector2i] = []	
	for cell in get_used_cells():
		checked_cells.append(target_cell + cell)
	
	# First of all, check terrains, as long as a terrain requirement is specified.
	if not terrain.is_empty():
		if not _check_terrain(checked_cells, get_terrain_at_cells):
			return false
	
	# Next, check for occupants.
	if not _check_occupants(checked_cells, get_occupants):
		return false
	
	# Passed all checks, return true.
	return true


func _check_occupants(target_cells: Array[Vector2i], get_occupants: Callable) -> bool:
	var occupants: Dictionary = get_occupants.call(target_cells)
	var occupant_values: = occupants.values()
	#if occupants:
		#return false
	#return true
	
	match operation:
		Operations.ALL:
			if construction_types.is_empty():
				return true
			
			for cnst_data in occupant_values:
				if cnst_data not in construction_types:
					return false
		
		Operations.NONE:
			if construction_types.is_empty() and not occupants.is_empty():
				return false
			
			for cnst_data in occupant_values:
				if cnst_data in construction_types:
					return false
		
		Operations.LESS_THAN:
			if construction_types.is_empty():
				return true
			
			var occurrences: = 0
			for cnst_data in construction_types:
				occurrences += occupant_values.count(cnst_data)
			if occurrences >= construction_quantity:
				return false
		
		Operations.MORE_THAN:
			if construction_types.is_empty():
				return true
			
			var occurrences: = 0
			for cnst_data in construction_types:
				occurrences += occupant_values.count(cnst_data)
			if occurrences <= construction_quantity:
				return false
		
		Operations.EXACTLY:
			if construction_types.is_empty():
				return true
			
			var occurrences: = 0
			for cnst_data in construction_types:
				occurrences += occupant_values.count(cnst_data)
			if occurrences != construction_quantity:
				return false
	
	return true


func _check_terrain(target_cells: Array[Vector2i], get_terrain_at_cells: Callable) -> bool:
	var terrain_types: Dictionary = get_terrain_at_cells.call(target_cells)
	var terrain_values: = terrain_types.values()
	
	# ALL terrain IDs in this requirement must match one of the types set in "terrain". Or, if
	# terrain is empty, anything goes.
	match operation:
		Operations.ALL:
			for terrain_name in terrain_values:
				if terrain_name not in terrain:
					return false
		
		Operations.NONE:
			for terrain_name in terrain_values:
				if terrain_name in terrain:
					return false
		
		Operations.LESS_THAN:
			var occurrences: = 0
			for terrain_name in terrain:
				occurrences += terrain_values.count(terrain_name)
			if occurrences >= terrain_quantity:
				return false
		
		Operations.MORE_THAN:
			var occurrences: = 0
			for terrain_name in terrain:
				occurrences += terrain_values.count(terrain_name)
			if occurrences <= terrain_quantity:
				return false
		
		Operations.EXACTLY:
			var occurrences: = 0
			for terrain_name in terrain:
				occurrences += terrain_values.count(terrain_name)
			if occurrences != terrain_quantity:
				return false
	
	return true
