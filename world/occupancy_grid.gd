class_name OccupancyGrid extends TileMapLayer

const CELL_COORDS: = Vector2i(17, 7)


func are_cells_occupied(cells: Array[Vector2i]) -> bool:
	var occupied_cells: = get_used_cells()
	for cell in cells:
		if cell in occupied_cells:
			return true
	return false


func set_cell_occupancy(cells: Array[Vector2i], is_occupied: bool) -> void:
	for cell in cells:
		if is_occupied:
			set_cell(cell, 0, CELL_COORDS)
		
		else:
			erase_cell(cell)
