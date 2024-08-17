class_name ConstructionRequirement extends TileMapLayer

enum Operation { ALL, NONE, MORE_THAN, LESS_THAN, EXACTLY }
@export var operation: = Operation.ALL

# See terrain.gd. This really should match.
@export_flags("None", "Grass", "RoadDirt", "River", "Cliff", "Trees") var terrain: = 0

# Look for a number of constructions. If multiple are provided, it is an "or" relationship.
@export var construction_type: Array[ConstructionData]


func _ready() -> void:
	print(terrain)


func validate_requirement(target_cell:Vector2i, get_occupants: Callable) -> bool:
	var checked_cells: Array[Vector2i] = []	
	for cell in get_used_cells():
		checked_cells.append(target_cell + cell)
	var occupants = get_occupants.call(checked_cells)
	print(occupants, " ", checked_cells)
	if occupants:
		return false
	return true
