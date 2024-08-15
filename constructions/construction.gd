class_name Construction extends Node2D

const COLOUR_PLACED: = Color.WHITE
const COLOUR_INVALID: = Color(1.0, 0.0, 0.0, 0.7)
const COLOUR_VALID: = Color(0.0, 1.0, 0.0, 0.7)

var cell: Vector2i
var _offset_cells: Array[Vector2i] = []


func _ready() -> void:
	var cell_layer: = $OccupiedCells as TileMapLayer
	_offset_cells = cell_layer.get_used_cells()
	cell_layer.queue_free()


func place(destination: Vector2i, destination_cell: Vector2i) -> Array[Vector2i]:
	position = destination
	cell = destination_cell
	
	modulate = COLOUR_PLACED
	
	return get_occupied_cells(cell)


func get_occupied_cells(origin_cell: Vector2i) -> Array[Vector2i]:
	var used_cells: Array[Vector2i] = []
	for offset: Vector2i in _offset_cells:
		used_cells.append(origin_cell + offset)
	
	return used_cells


func flag_as_invalid() -> void:
	modulate = COLOUR_INVALID


func flag_as_valid() -> void:
	modulate = COLOUR_VALID
