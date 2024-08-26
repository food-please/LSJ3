extends Node

@onready var camera: = $TouchCamera as TouchCamera
@onready var terrain: = $World/Terrain as TileMapLayer

@onready var _citizens: = $UI/CitizenBar as CitizenBar

func _ready() -> void:
	randomize()
	
	Events.construction_placed.connect(_on_construction_placed)
	
	# Setup the camera, its starting position, and its boundaries.
	var viewport_dimensions: = get_viewport().get_visible_rect().size
	var map_dimensions: = terrain.get_used_rect()
	camera.boundary = Rect2(
		map_dimensions.position * terrain.tile_set.tile_size + Vector2i(viewport_dimensions/2.0),
		map_dimensions.size * terrain.tile_set.tile_size - Vector2i(viewport_dimensions)
	)
	
	for i in range(0, 4):
		_citizens.add_random_citizen()
	
	Music.start()


func _on_construction_placed(_cnst: Construction) -> void:
	await get_tree().process_frame
	if Dwellings.uniques_remaining.is_empty() and not _citizens.has_unique_citizens():
		print("Win")
