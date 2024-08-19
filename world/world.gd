class_name World extends Node2D

# Store features/terrain types according to name.


# Note that the terrain layer acts as the world's grid/playable area.
@onready var terrain: = $Terrain as TileMapLayer
@onready var _terrain_tileset: = terrain.tile_set
@onready var features: = $Features as TileMapLayer
@onready var _features_tileset: = features.tile_set

# Key = cell, value = terrain type name
var _features: = {}
var _terrain: = {}


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
