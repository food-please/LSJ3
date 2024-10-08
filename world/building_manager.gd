class_name BuildingManager extends Node2D

const CONSTRUCTION: = preload("res://constructions/construction.tscn")

const COLOR: = [ Color.WHITE, Color(1.0, 0.0, 0.0, 0.7), Color(0.0, 1.0, 0.0, 0.7)]

@export var clouds: CloudCover

@export var occupants: OccupiedTiles

@export var world: World

@export var erase_button: TextureButton
@export var trash_can: TrashCan

@export_category("Camera")
@export var camera: TouchCamera

@export var cursor_scroll_limits: = Rect2i(20, 20, 216, 104)
@export var cursor_scroll_speed: = 64.0

var _grid: TileMapLayer
var _tileset: TileSet

var is_erase_mode: bool = false:
	set(value):
		is_erase_mode = value
		
		if is_erase_mode:
			_free_blueprint()
			_active_data = null

var _active_data: ConstructionData = null
var _construction_blueprint: Construction = null

var _drag_distance: = 0.0

@onready var passable_cells: = $PassabilityGrid as PassableTiles


func _ready() -> void:
	trash_can.mouse_entered.connect(_on_trash_can_mouse_entered)
	trash_can.mouse_exited.connect(_on_trash_can_mouse_exited)
	
	await get_tree().root.ready
	
	assert(occupants, "The building manager must have a path to the OccupiedTiles object!")
	assert(world, "The building manager must have a path to the World object!")
	_grid = world.terrain
	assert(_grid, "The building manager must have a TileMapLayer that defines the playable grid!")
	_tileset = _grid.tile_set
	assert(_tileset, "The grid must have a tileset for buildings to be placed!")
	
	assert(trash_can, "The building manager needs an available trash can!")
	#trash_can.gui_input.connect(_on_trash_can_gui_input)
	
	assert(camera, "The building manager needs a camera!")
	
	Events.construction_data_selected.connect(
		func(data: ConstructionData, _anchor: RemoteTransform2D):
			is_erase_mode = false
			
			_active_data = data
			if _active_data:
				assert(_active_data.variations.size(), "Construction blueprint has no variations!")
	)
	
	Events.erase_selected.connect(func(toggled: bool): is_erase_mode = toggled)
	
	set_process(false)


func _process(delta: float) -> void:
	if not _construction_blueprint:
		set_process(false)
		return
	
	var scroll: = Vector2.ZERO
	var mouse_pos: = get_viewport().get_mouse_position()
	if mouse_pos.x < cursor_scroll_limits.position.x:
		scroll.x = -1
	elif mouse_pos.x > cursor_scroll_limits.end.x:
		scroll.x = 1
	
	if mouse_pos.y < cursor_scroll_limits.position.y:
		scroll.y = -1
	elif mouse_pos.y > cursor_scroll_limits.end.y:
		scroll.y = 1
	
	camera.scroll(scroll.normalized() * cursor_scroll_speed * delta)


func _unhandled_input(event: InputEvent) -> void:
	if is_erase_mode:
		if event.is_action_pressed("touch"):
			_drag_distance = 0.0
			get_viewport().set_input_as_handled()
			
		elif event.is_action_released("touch"):
			if _drag_distance <= 10.0:
				var cell: = _grid.local_to_map(get_global_mouse_position())
				
				Events.cell_erased.emit(cell)
				get_viewport().set_input_as_handled()
		
		elif event is InputEventMouseMotion and Input.is_action_pressed("touch"):
			_drag_distance += event.relative.length()
			camera.scroll(-event.relative)
	
	elif _active_data != null:
		if event is InputEventScreenDrag and _construction_blueprint != null:
			var cell: = _grid.local_to_map(get_global_mouse_position())
			var target: = _grid.map_to_local(cell)
			_move_construction_to_cell(_construction_blueprint, cell, target)
		
		elif event.is_action_pressed("touch"):
			_setup_new_blueprint_from_data()
			get_viewport().set_input_as_handled()
			
		elif event.is_action_released("touch") and _construction_blueprint:
			if _construction_blueprint.visible:
				_place_construction()
			
			else:
				_free_blueprint()
				Events.construction_binned.emit()
			get_viewport().set_input_as_handled()
	
	else:
		if event.is_action_released("touch"):
			
			var cell: = _grid.local_to_map(get_global_mouse_position())
			var construction: = passable_cells.get_construction_at_cell(cell)
			if construction is ConstructionVariation:
				construction.increment_index()


func erase_cell(cell: Vector2i) -> bool:
	if clouds.are_cells_clear([cell]):
		var construction: = passable_cells.get_construction_at_cell(cell)
		if construction:
			passable_cells.set_cell_occupancy(
				construction.get_occupied_cells(construction.cell),
				false,
				null,
				null
			)
			construction.queue_free()
			
			Events.construction_erased.emit(construction)
			return true
	return false


func _setup_new_blueprint_from_data() -> void:
	assert(_active_data, "Trying to setup a construction blueprint, but there's no data!")
	
	#_construction_blueprint = CONSTRUCTION.instantiate()
	var variation: = randi() % _active_data.variations.size()
	var new_construction: = _active_data.variations[variation].instantiate()
	assert(new_construction is Construction, "Trying to create a blueprint from something that " +
		"is not a construction!")
	_construction_blueprint = new_construction
	add_child(_construction_blueprint)
	
	var cell: = _grid.local_to_map(get_global_mouse_position())
	var target: = _grid.map_to_local(cell)
	if _construction_blueprint.has_method("setup_preview"):
		_construction_blueprint.setup_preview(cell, target)
	
	_move_construction_to_cell(_construction_blueprint, cell, target)
	
	erase_button.hide()
	trash_can.show()
	set_process(true)


func _move_construction_to_cell(construction: Construction, cell: Vector2i, 
		target: Vector2i) -> void:
	construction.preview_at_position(target)
	
	var occupied_cells: = construction.get_occupied_cells(cell)
	
	if not clouds.are_cells_clear(occupied_cells):
		construction.flag_as_invalid()
		return 
	
	if construction is ConstructionDwelling:
		if occupants.do_cells_have_citizens(occupied_cells):
			construction.flag_as_invalid()
			return
	
	elif construction is TerrainConstruction:
		if construction.value * construction.get_cells().size() > Economy.points:
			_construction_blueprint.flag_as_invalid()
			return
	
	else:
		if _construction_blueprint.value > Economy.points:
			_construction_blueprint.flag_as_invalid()
			return
	
	if not construction.evaluate_requirements(cell, passable_cells.get_occupant_data, 
			world.get_terrain_at_cells):
		construction.flag_as_invalid()
	
	else:
		construction.flag_as_valid()


func _place_construction() -> bool:
	var cell: = _grid.local_to_map(get_global_mouse_position())
	var target: = _grid.map_to_local(cell)
	var changed_cells: = _construction_blueprint.place(target, cell)
	
	erase_button.show()
	trash_can.hide()
	if not _construction_blueprint.is_valid:
		_free_blueprint()
		Events.invalid_construction_placed.emit()
		return false
	
	if _construction_blueprint is not TerrainConstruction \
			and _construction_blueprint is not ConstructionDwelling:
		passable_cells.set_cell_occupancy(changed_cells, true, _construction_blueprint, 
			_active_data)
	
	if _construction_blueprint is ConstructionHouse:
		if world.get_terrain_at_cell(_construction_blueprint.cell + Vector2i.DOWN) == "RoadDirt":
			_construction_blueprint.face_direction("down")
		elif world.get_terrain_at_cell(_construction_blueprint.cell + Vector2i.UP) == "RoadDirt":
			_construction_blueprint.face_direction("up") 
		elif world.get_terrain_at_cell(_construction_blueprint.cell + Vector2i.LEFT) == "RoadDirt":
			_construction_blueprint.face_direction("left") 
		elif world.get_terrain_at_cell(_construction_blueprint.cell + Vector2i.RIGHT) == "RoadDirt":
			_construction_blueprint.face_direction("right")
	
	elif _construction_blueprint is ConstructionBridge:
		if world.get_terrain_at_cell(_construction_blueprint.cell + Vector2i.DOWN) == "River" or\
				world.get_terrain_at_cell(_construction_blueprint.cell + Vector2i.UP) == "River":
			_construction_blueprint.face_direction("h")
		else:
			_construction_blueprint.face_direction("v") 
	
	Events.construction_placed.emit(_construction_blueprint)
	_construction_blueprint = null
	
	return true


func _free_blueprint() -> void:
	if _construction_blueprint:
		_construction_blueprint.queue_free()
	_construction_blueprint = null
	
	erase_button.show()
	trash_can.hide()


#func _on_trash_can_gui_input(event: InputEvent) -> void:
	#print("Placed here?")
	#if event.is_action_released("touch"):
		#_construction_blueprint.queue_free()
		#_construction_blueprint = null
		#
		#trash_can.hide()
		#print("Placed here?")
		#get_viewport().set_input_as_handled()


func _on_trash_can_mouse_entered() -> void:
	if _construction_blueprint:
		_construction_blueprint.hide()


func _on_trash_can_mouse_exited() -> void:
	if _construction_blueprint:
		_construction_blueprint.show()
