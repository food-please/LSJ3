extends Node

@export var start_cells: TileMapLayer

@export var starting_citizens: = 3

var camera_extents: Rect2i

@onready var camera: = $TouchCamera as TouchCamera
@onready var terrain: = $World/Terrain as TileMapLayer

@onready var _citizens: = $UI/CitizenBar as CitizenBar
@onready var _clouds: = $World/Clouds as CloudCover
@onready var _construction_animations: = $UI/ConstructionBar/AnimationPlayer as AnimationPlayer
@onready var _points_animations: = $UI/Points/AnimationPlayer as AnimationPlayer


func _ready() -> void:
	randomize()
	
	Progression.are_uniques_in_citizen_bar = _citizens.has_unique_citizens
	Progression.game_started.connect(start)
	Progression.first_house_placed.connect(_on_1st_construction_placed)
	Progression.first_worker_placed.connect(_on_1st_worker_placed)
	Progression.first_unique_placed.connect(_on_1st_unique_placed)
	Progression.game_won.connect(_on_win)
	
	# Setup the camera, its starting position, and its boundaries.
	var viewport_dimensions: = get_viewport().get_visible_rect().size
	var map_dimensions: = terrain.get_used_rect()
	
	camera_extents = Rect2i(
		map_dimensions.position * terrain.tile_set.tile_size + Vector2i(viewport_dimensions/2.0),
		map_dimensions.size * terrain.tile_set.tile_size - Vector2i(viewport_dimensions)
	)
	
	var start_pos: = start_cells.get_used_rect()
	camera.position = (start_pos.position + start_pos.size/2) * start_cells.tile_set.tile_size
	#camera.position = camera.boundary.position + camera.boundary.size/2
	
	_clouds.cover_changed.connect(_update_camera_bounds)
	
	#TODO: remove
	#$Screens/LogoScreen.queue_free()
	#$Screens/TitleScreen.queue_free()
	#Progression.game_started.emit()


func start() -> void:
	_clouds.reveal_cells(start_cells.get_used_cells())
	start_cells.queue_free()
	
	await get_tree().create_timer(.5).timeout
	
	_construction_animations.play("appear")
	_points_animations.play("appear")
	
	#for i in range(0, starting_citizens):
		#_citizens.add_random_citizen()
	
	_update_camera_bounds()


func _update_camera_bounds() -> void:
	var cloud_bounds: = _clouds.get_revealed_camera_extents()
	
	var bounds_begin: = Vector2i(
		max(camera_extents.position.x, cloud_bounds.position.x),
		max(camera_extents.position.y, cloud_bounds.position.y)
	)
	
	var bounds_end: = Vector2i(
		min(camera_extents.end.x, cloud_bounds.end.x),
		min(camera_extents.end.y, cloud_bounds.end.y)
	)
	
	var new_boundary: = Rect2i(
		max(camera_extents.position.x, cloud_bounds.position.x),
		max(camera_extents.position.y, cloud_bounds.position.y),
		max(0, bounds_end.x - bounds_begin.x),
		max(0, bounds_end.y - bounds_begin.y)
	)
	
	camera.boundary = new_boundary


func _on_1st_construction_placed() -> void:
	_construction_animations.play("disappear")
	Events.construction_data_selected.emit(null, null)
	
	var dwelling_data: = preload("res://constructions/dwellings/cnst_generic_dwelling1_data.tres")
	_citizens.add_citizen(Constants.CITIZEN_COLOURS.Green, dwelling_data)


func _on_1st_worker_placed() -> void:
	_construction_animations.play("appear")
	Music.start()
	
	$UI/ConstructionBar/VBoxContainer/ConstructionsBar.category = \
		preload("res://constructions/cnst_cat_2.tres")


func _on_1st_unique_placed() -> void:
	_construction_animations.play("disappear")
	await _construction_animations.animation_finished
	
	$UI/ConstructionBar/VBoxContainer/ConstructionsBar.category = \
		preload("res://constructions/cnst_cat_3.tres")
	_construction_animations.play("appear")


func _on_win() -> void:
	_construction_animations.play("disappear")
	
	var thanks_screen: = preload("res://splash/thanks.tscn").instantiate()
	$Screens.add_child(thanks_screen)
	await thanks_screen.finished
	
	$UI/ConstructionBar/VBoxContainer/ConstructionsBar.category = \
		preload("res://constructions/cnst_cat_all.tres")
	_construction_animations.play("appear")
