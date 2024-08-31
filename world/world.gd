class_name World extends Node2D

# Probably grass.
const DEFAULT_SET: = 0
const DEFAULT_TERRAIN: = 3

# Key = cell, value = terrain type name
#var _features: = {}
var _terrain: = {}

# Note that the terrain layer acts as the world's grid/playable area.
@onready var cloud_cover: = $Clouds as CloudCover
@onready var terrain: = $Terrain as TileMapLayer
@onready var _terrain_tileset: = terrain.tile_set
#@onready var features: = $Features as TileMapLayer
#@onready var _features_tileset: = features.tile_set

@onready var buildings: = $Buildings as BuildingManager


func _ready() -> void:
	_update_terrain(terrain.get_used_cells())
	
	Events.construction_placed.connect(_on_construction_placed)
	Events.cell_erased.connect(erase_cell)


func erase_cell(cell: Vector2i) -> void:
	if cloud_cover.are_cells_clear([cell]) and not buildings.erase_cell(cell):
		#var surrounding_cells: = features.get_surrounding_cells(cell)
		#features.erase_cell(cell)
		#for updated_cell in surrounding_cells:
			#var tile_data: = features.get_cell_tile_data(updated_cell)
			#if tile_data:
				#features.set_cells_terrain_connect([updated_cell], tile_data.terrain_set, 
					#tile_data.terrain)
		
		var unerasable: = [
			"sea",
			"cliff",
			"trees",
			"sand",
			"river"
		]
		if get_terrain_at_cell(cell).to_lower() not in unerasable:
			terrain.set_cells_terrain_connect([cell], DEFAULT_SET, DEFAULT_TERRAIN)
			var updated_rect: = Rect2i(cell, Vector2i(1, 1))
			updated_rect = updated_rect.grow(1)
			
			#for cell in cells_to_update:
				#updated_rect.expand(cell)
			_update_autotiles(updated_rect)
			
			_update_terrain([cell])


# Returns a dictionary with key = cell coords and value = terrain name (String)
func get_terrain_at_cells(cells: Array[Vector2i]) -> Dictionary:
	var terrain_ids: = {}
	for cell in cells:
		terrain_ids[cell] = get_terrain_at_cell(cell)
	return terrain_ids


func get_terrain_at_cell(cell: Vector2i) -> String:
	#var terrain_name: = ""
	#terrain_name = _features.get(cell, "")
	#if terrain_name.is_empty():
		#terrain_name = _terrain.get(cell, "")
	#return terrain_name
	return _terrain.get(cell, "")
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
		
			#terrain.set_cells_terrain_connect([cell], 0, changes[cell])
		
		for cell: Vector2i in changes:
			updated_cells.append(cell)
		terrain.set_cells_terrain_connect(
			updated_cells, 
			terrain_construction.terrain_set, 
			terrain_construction.terrain_id
			)
		
		if terrain_construction.terrain_type == "area":
			terrain.set_cells_terrain_connect(
			updated_cells, 
			terrain_construction.terrain_set, 
			terrain_construction.terrain_id
			)
			
			var affected_cells: = terrain_construction.get_affected_cells()
			_update_autotiles(affected_cells)
		
		terrain_construction.queue_free()
		
		_update_terrain(updated_cells)
		
		Economy.points -= construction.value * changes.size()
		Economy.add_score(construction.value * changes.size())
	
	elif construction is ConstructionDwelling:
		Economy.points += construction.value
		Economy.add_score(construction.value)
	
	else:
		Economy.points -= construction.value
		Economy.add_score(construction.value)


func _update_autotiles(cells_to_update: Rect2i) -> void:
	#if cells_to_update.is_empty():
		#return
	#
	#var updated_rect: = Rect2i(cells_to_update[0], Vector2i(1, 1))
	#for cell in cells_to_update:
		#updated_rect.expand(cell)
	
	# Key is terrain id, value is an array of all cells in the source rect that match this terrain.
	var terrains: = {}
	
	# Find all terrains that are contained by the source rect.
	for x in range(0, cells_to_update.size.x):
		for y in range(0, cells_to_update.size.y):
			var cell: = Vector2i(x, y)
			var tile_data: = terrain.get_cell_tile_data(cell)
			var terrain_id: = [tile_data.terrain_set, tile_data.terrain]
			if terrain_id in terrains:
				terrains.get(terrain_id, []).append(cell)
			else:
				terrains[terrain_id] = [cell]
	
	# Loop through all terrains, updating all cells matching this terrain type at once.
	for terrain_id in terrains:
		terrain.set_cells_terrain_connect(terrains[terrain_id], terrain_id[0], terrain_id[1])


func _update_terrain(updated_cells: Array[Vector2i]) -> void:
	for cell in updated_cells:
		#var cell_data: = features.get_cell_tile_data(cell)
		#if cell_data:
			#var feature: = \
				#_features_tileset.get_terrain_name(cell_data.terrain_set, cell_data.terrain)
			#_features[cell] = feature
		
		# No terrain features, so look for terrain instead.
		var cell_data: = terrain.get_cell_tile_data(cell)
		if cell_data.terrain_set >= 0 and cell_data.terrain >= 0:
			var ground = _terrain_tileset.get_terrain_name(cell_data.terrain_set, cell_data.terrain)
			_terrain[cell] = ground
