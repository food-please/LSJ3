class_name OccupiedTiles extends TileMapLayer

const TileSource: = Vector2i(28, 3)


func _ready() -> void:
	hide()
	
	Events.construction_placed.connect(_on_construction_placed)
	
	Events.construction_data_selected.connect(_on_construction_data_selected)
	
	Events.erase_selected.connect(
		func(_toggle: bool):
			hide()
	)
	
	Events.construction_erased.connect(
		func(cnst: Construction):
			for cell: Vector2i in cnst.get_occupied_cells(cnst.cell):
				erase_cell(cell)
	)


func do_cells_have_citizens(cells: Array[Vector2i]) -> bool:
	var used_cells: = get_used_cells()
	for cell in cells:
		if cell in used_cells:
			return true
	return false


func _on_construction_data_selected(data: ConstructionData, _anchor: RemoteTransform2D) -> void:
	if data:
		var new_cnst: = data.variations[0].instantiate()
		if new_cnst is ConstructionDwelling:
			show()
		new_cnst.free()
		return
	
	hide()


func _on_construction_placed(construction: Construction) -> void:
	if construction is ConstructionDwelling:
		for cell: Vector2i in construction.get_occupied_cells(construction.cell):
			set_cell(cell, 0, TileSource)
