class_name PassableTiles extends TileMapLayer

const CELL_COORDS: = Vector2i(28, 3)

# Keys: cell coordinates, Value: construction data, construction pairs
var _construction_data: = {}
#
## Keys: construction, Value: cells
#var _constructions: = {}


func _ready() -> void:
	hide()


# Returns a dictionary with keys = cell coords and values = construction data (note: multiple
# constructions can share the same data, and multi-cell constructions count for each cell they
# occupy. That is, a 3x3 construction shows up 9 times.)
func get_occupant_data(cells: Array[Vector2i]) -> Dictionary:
	var occupants: = {}
	for cell in cells:
		if cell in _construction_data:
			occupants[cell] = _construction_data[cell][0]
	return occupants


# Same as above, but returns values that are constructions.
#func get_occupants(cells: Array[Vector2i]) -> Dictionary:
	#var occupants: = {}
	#for cell in cells:
		#if cell in _construction_data:
			#occupants[cell] = _construction_data[cell]
	#return occupants


func get_construction_at_cell(cell: Vector2i) -> Construction:
	var occupants = _construction_data.get(cell)
	if occupants:
		return occupants[1] as Construction
	return null


func set_cell_occupancy(cells: Array[Vector2i], is_occupied: bool, construction: Construction,
		data: ConstructionData) -> void:
	for cell in cells:
		if is_occupied:
			set_cell(cell, 0, CELL_COORDS)
			_construction_data[cell] = [data, construction]
		
		else:
			erase_cell(cell)
			_construction_data.erase(cell)
