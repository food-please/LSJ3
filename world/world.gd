class_name World extends Node2D

# Store features/terrain types according to name.


# Note that the terrain layer acts as the world's grid/playable area.
@onready var terrain: = $Terrain as TileMapLayer
@onready var _terrain_tileset: = terrain.tile_set
@onready var features: = $Features as TileMapLayer
@onready var _features_tileset: = features.tile_set


func get_terrain_at_cell(cell: Vector2i) -> void:
	var cell_data: = features.get_cell_tile_data(cell)
	if cell_data:
		pass
		#print(_features_tileset.get_terrain_name(cell_data.terrain_set, cell_data.terrain))
	if not cell_data:
		cell_data = terrain.get_cell_tile_data(cell)
		if cell_data:
			pass
			#print(_terrain_tileset.get_terrain_name(cell_data.terrain_set, cell_data.terrain))
	if not cell_data:
		return
	
	#print(cell_data.terrain_set, " ", cell_data.terrain)
