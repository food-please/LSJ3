extends Node

@onready var camera: = $TouchCamera as TouchCamera
@onready var terrain: = $World/Terrain as TileMapLayer

func _ready() -> void:
	# Setup the camera, its starting position, and its boundaries.
	var viewport_dimensions: = get_viewport().get_visible_rect().size
	var map_dimensions: = terrain.get_used_rect()
	camera.boundary = Rect2(
		map_dimensions.position * terrain.tile_set.tile_size + Vector2i(viewport_dimensions/2.0),
		map_dimensions.size * terrain.tile_set.tile_size - Vector2i(viewport_dimensions)
	)
