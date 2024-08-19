class_name OccupancyGrid extends TileMapLayer

const CELL_COORDS: = Vector2i(0, 0)

# Keys: cell coordinates, Value: construction data
var _construction_data: = {}


# Returns a dictionary with keys = cell coords and values = construction data (note: multiple
# constructions can share the same data, and multi-cell constructions count for each cell they
# occupy. That is, a 3x3 construction shows up 9 times.)
func get_occupants(cells: Array[Vector2i]) -> Dictionary:
	var occupants: = {}
	for cell in cells:
		if cell in _construction_data:
			occupants[cell] = _construction_data[cell]
	return occupants


func set_cell_occupancy(cells: Array[Vector2i], is_occupied: bool, data: ConstructionData) -> void:
	for cell in cells:
		if is_occupied:
			set_cell(cell, 1, CELL_COORDS)
			_construction_data[cell] = data
		
		else:
			erase_cell(cell)
			_construction_data.erase(cell)
