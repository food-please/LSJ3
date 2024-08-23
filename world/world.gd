class_name World extends Node2D

# Probably grass.
const DEFAULT_TERRAIN: = 3

# Key = cell, value = terrain type name
var _features: = {}
var _terrain: = {}

# Note that the terrain layer acts as the world's grid/playable area.
@onready var terrain: = $Terrain as TileMapLayer
@onready var _terrain_tileset: = terrain.tile_set
@onready var features: = $Features as TileMapLayer
@onready var _features_tileset: = features.tile_set

@onready var buildings: = $Buildings as BuildingManager


func _ready() -> void:
	_update_terrain(terrain.get_used_cells())
	
	Events.construction_placed.connect(_on_construction_placed)
	Events.cell_erased.connect(erase_cell)


func erase_cell(cell: Vector2i) -> void:
	if not buildings.erase_cell(cell):
		var surrounding_cells: = features.get_surrounding_cells(cell)
		features.erase_cell(cell)
		for updated_cell in surrounding_cells:
			var tile_data: = features.get_cell_tile_data(updated_cell)
			if tile_data:
				features.set_cells_terrain_connect([updated_cell], tile_data.terrain_set, 
					tile_data.terrain)
		terrain.set_cells_terrain_connect([cell], 0, DEFAULT_TERRAIN)
		
		_update_terrain([cell])


# Returns a dictionary with key = cell coords and value = terrain name (String)
func get_terrain_at_cells(cells: Array[Vector2i]) -> Dictionary:
	var terrain_ids: = {}
	for cell in cells:
		terrain_ids[cell] = get_terrain_at_cell(cell)
	return terrain_ids


func get_terrain_at_cell(cell: Vector2i) -> String:
	var terrain_name: = ""
	terrain_name = _features.get(cell, "")
	if terrain_name.is_empty():
		terrain_name = _terrain.get(cell, "")
	return terrain_name
	#if _features.has(cell):
		#return _features
	#var cell_data: = features.get_cell_tile_data(cell)
	#if cell_data:
		#pass
		##print(_features_tileset.get_terrain_name(cell_data.terrain_set, cell_data.terrain))
	#if not cell_data:
		#cell_data = terrain.get_cell_tile_data(cell)
		#if cell_data:
			#pass
			##print(_terrain_tileset.get_terrain_name(cell_data.terrain_set, cell_data.terrain))
	#if not cell_data:
		#return
	
	#print(cell_data.terrain_set, " ", cell_data.terrain)


func _on_construction_placed(construction: Construction) -> void:
	var terrain_construction: = construction as TerrainConstruction
	if terrain_construction:
		var changes: = terrain_construction.get_cells()
		var updated_cells: Array[Vector2i] = []
		for cell: Vector2i in changes:
			updated_cells.append(cell)
			terrain.set_cells_terrain_connect([cell], 0, changes[cell])
		
		terrain_construction.queue_free()
		
		_update_terrain(updated_cells)


func _update_terrain(updated_cells: Array[Vector2i]) -> void:
	for cell in updated_cells:
		var cell_data: = features.get_cell_tile_data(cell)
		if cell_data:
			var feature: = \
				_features_tileset.get_terrain_name(cell_data.terrain_set, cell_data.terrain)
			_features[cell] = feature
		
		# No terrain features, so look for terrain instead.
		cell_data = terrain.get_cell_tile_data(cell)
		var ground = _terrain_tileset.get_terrain_name(cell_data.terrain_set, cell_data.terrain)
		_terrain[cell] = ground
