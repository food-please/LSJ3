class_name World extends Node2D

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
	for cell in terrain.get_used_cells():
		var cell_data: = features.get_cell_tile_data(cell)
		if cell_data:
			var feature: = \
				_features_tileset.get_terrain_name(cell_data.terrain_set, cell_data.terrain)
			_features[cell] = feature
		
		# No terrain features, so look for terrain instead.
		cell_data = terrain.get_cell_tile_data(cell)
		var ground = _terrain_tileset.get_terrain_name(cell_data.terrain_set, cell_data.terrain)
		_terrain[cell] = ground
	
	Events.construction_placed.connect(_on_construction_placed)


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
		for cell in changes:
			terrain.set_cells_terrain_connect([cell], 0, changes[cell])
		
		buildings.clear_passability(terrain_construction.cell)
		terrain_construction.queue_free()
