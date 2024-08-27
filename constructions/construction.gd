class_name Construction extends Node2D

const COLOUR_PLACED: = Color.WHITE
const COLOUR_INVALID: = Color(1.0, 0.0, 0.0, 0.7)
const COLOUR_VALID: = Color(0.0, 1.0, 0.0, 0.7)

@export var vision: = 1

@export var value: = 100

var cell: Vector2i
var is_valid: bool = false
var _offset_cells: Array[Vector2i] = []

var _requirements: Array[Node] = []


func _ready() -> void:
	var cell_layer: = $OccupiedCells as TileMapLayer
	_offset_cells = cell_layer.get_used_cells()
	#cell_layer.queue_free()
	
	_requirements = find_children("*", "ConstructionRequirement")
	#for requirement in _requirements:
		#requirement.hide()


func evaluate_requirements(target_cell: Vector2i, get_occupants: Callable, 
		get_terrain: Callable) -> bool:
	is_valid = true
	for requirement: ConstructionRequirement in _requirements:
		if not requirement.validate_requirement(target_cell, get_occupants, get_terrain):
			is_valid = false
	
	return is_valid


func place(destination: Vector2i, destination_cell: Vector2i) -> Array[Vector2i]:
	position = destination
	cell = destination_cell
	
	modulate = COLOUR_PLACED
	
	for requirement in _requirements:
		requirement.queue_free()
	
	return get_occupied_cells(cell)


func preview_at_position(target: Vector2) -> void:
	position = target


func get_occupied_cells(origin_cell: Vector2i) -> Array[Vector2i]:
	var used_cells: Array[Vector2i] = []
	for offset: Vector2i in _offset_cells:
		used_cells.append(origin_cell + offset)
	
	return used_cells


func flag_as_invalid() -> void:
	modulate = COLOUR_INVALID
	is_valid = false


func flag_as_valid() -> void:
	modulate = COLOUR_VALID
	is_valid = true
