extends Node

@onready var camera: = $TouchCamera as TouchCamera
@onready var terrain: = $World/Terrain as TileMapLayer

func _ready() -> void:
	randomize()
	
	# Setup the camera, its starting position, and its boundaries.
	var viewport_dimensions: = get_viewport().get_visible_rect().size
	var map_dimensions: = terrain.get_used_rect()
	camera.boundary = Rect2(
		map_dimensions.position * terrain.tile_set.tile_size + Vector2i(viewport_dimensions/2.0),
		map_dimensions.size * terrain.tile_set.tile_size - Vector2i(viewport_dimensions)
	)
	
	for i in range(0, 3):
		$UI/CitizenBar.add_random_citizen()
	
	#var random_key = \
		#Constants.CITIZEN_COLOURS.values()[randi() % Constants.CITIZEN_COLOURS.keys().size()]
	#$UI/CitizenBar.add_citizen(random_key, load("res://constructions/dwellings/dwelling_data.tres"))
	
	#random_key = \
		#Constants.CITIZEN_COLOURS.values()[randi() % Constants.CITIZEN_COLOURS.keys().size()]
	#$UI/CitizenBar.add_citizen(random_key, load("res://constructions/dwellings/dwelling_data2.tres"))
	#
	#random_key = \
		#Constants.CITIZEN_COLOURS.values()[randi() % Constants.CITIZEN_COLOURS.keys().size()]
	#$UI/CitizenBar.add_citizen(random_key, load("res://constructions/dwellings/dwelling_data3.tres"))
	
	
