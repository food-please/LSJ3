@tool
class_name TerrainConstruction extends Construction

@export_enum("path", "area") var terrain_type: = "path"

@export var terrain_id: = 0:
	set(value):
		if not is_inside_tree():
			await ready
		
		if not _preview.tile_set:
			return
		
		terrain_id = clampi(value, 0, _preview.tile_set.get_terrains_count(0))
		_preview.set_cells_terrain_connect([Vector2i.ZERO], 0, terrain_id)

@onready var _preview: = $Preview as TileMapLayer

var origin: = Vector2i.ZERO


func _ready() -> void:
	if not Engine.is_editor_hint():
		super._ready()


func setup_preview(origin_cell: Vector2i, target: Vector2) -> void:
	origin = origin_cell
	position = target


# DONT move the construction. Rather, run the tileset out to the given position.
func preview_at_position(target: Vector2) -> void:
	_preview.clear()
	var path_cells: Array[Vector2i] = []
	
	if terrain_type == "path":
		path_cells = _get_path_cells(target)
	
	else:
		path_cells = _get_area_cells(target)
	
	_preview.set_cells_terrain_connect(path_cells, 0, 0)
	
	print(path_cells)


func evaluate_requirements(target_cell: Vector2i, get_occupants: Callable, 
		get_terrain: Callable) -> bool:
	is_valid = true
	for requirement: ConstructionRequirement in _requirements:
		if not requirement.validate_requirement(target_cell, get_occupants, get_terrain):
			is_valid = false
	
	return is_valid


# Key = world cell coord, value = terrain id
func get_cells() -> Dictionary:
	var terrains: = {}
	for used_cell in _preview.get_used_cells():
		terrains[used_cell + origin] = _preview.get_cell_tile_data(used_cell).terrain
	return terrains


func _get_path_cells(target: Vector2) -> Array[Vector2i]:
	var path_cells: Array[Vector2i] = []
	
	var path_size_cells: Vector2i = (target - position)/8
	var is_x_larger: bool = abs(path_size_cells.x) > abs(path_size_cells.y)
	
	var x_offset: int = sign(path_size_cells.x)
	if x_offset == 0:
		x_offset = 1
	var y_offset: int = sign(path_size_cells.y)
	if y_offset == 0:
		y_offset = 1
	
	if is_x_larger:
		for x in range(0, path_size_cells.x + x_offset, x_offset):
			path_cells.append(Vector2i(x, 0))
		for y in range(y_offset, path_size_cells.y, y_offset):
			path_cells.append(Vector2i(path_size_cells.x, y))
	
	else:
		for y in range(0, path_size_cells.y + y_offset, y_offset):
			path_cells.append(Vector2i(0, y))
		for x in range(x_offset, path_size_cells.x, x_offset):
			path_cells.append(Vector2i(x, path_size_cells.y))
	
	path_cells.append(path_size_cells)
	
	return path_cells


func _get_area_cells(target: Vector2) -> Array[Vector2i]:
	var area_cells: Array[Vector2i] = []
	
	var path_size_cells: Vector2i = (target - position)/8
	var x_offset: int = sign(path_size_cells.x)
	if x_offset == 0:
		x_offset = 1
	var y_offset: int = sign(path_size_cells.y)
	if y_offset == 0:
		y_offset = 1
	
	for x in range(0, path_size_cells.x + x_offset, x_offset):
		for y in range(0, path_size_cells.y + y_offset, y_offset):
			area_cells.append(Vector2i(x, y))
	
	return area_cells
