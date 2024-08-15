class_name Terrain extends RefCounted

enum Types {
	Grass,
	RoadDirt,
	River,
	Cliff,
	Trees
}

const Icons: = {
	Types.Grass: preload("res://world/tilesets/terrains/terrain_icon_grass.atlastex"),
	
	Types.RoadDirt: preload("res://world/tilesets/terrains/terrain_icon_road_dirt.atlastex"),
	
	Types.River: preload("res://world/tilesets/terrains/terrain_icon_river.atlastex"),
	
	Types.Cliff: preload("res://world/tilesets/terrains/terrain_icon_cliffs.atlastex"),
	
	Types.Trees: preload("res://world/tilesets/terrains/terrain_icon_trees.atlastex"),
}
