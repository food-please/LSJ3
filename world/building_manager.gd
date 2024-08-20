extends Node2D

const CONSTRUCTION: = preload("res://constructions/construction.tscn")

const COLOR: = [ Color.WHITE, Color(1.0, 0.0, 0.0, 0.7), Color(0.0, 1.0, 0.0, 0.7)]

@export var world: World

@export var trash_can: TrashCan

@export_category("Camera")
@export var camera: TouchCamera

@export var cursor_scroll_limits: = Rect2i(20, 20, 216, 104)
@export var cursor_scroll_speed: = 64.0

var _grid: TileMapLayer
var _tileset: TileSet

var _active_data: ConstructionData = null
var _construction_blueprint: Construction = null

@onready var passable_cells: = $PassabilityGrid as OccupancyGrid


func _ready() -> void:
	trash_can.mouse_entered.connect(_on_trash_can_mouse_entered)
	trash_can.mouse_exited.connect(_on_trash_can_mouse_exited)
	
	set_process_unhandled_input(false)
	
	await get_tree().root.ready
	
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
			_active_data = data
			if _active_data:
				assert(_active_data.variations.size(), "Construction blueprint has no variations!")
			set_process_unhandled_input(data != null)
	)
	
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
	if event is InputEventScreenDrag and _construction_blueprint != null:
		var cell: = _grid.local_to_map(get_global_mouse_position())
		var target: = _grid.map_to_local(cell)
		_move_construction_to_cell(_construction_blueprint, cell, target)
	
	elif event.is_action_pressed("touch"):
		_setup_new_blueprint_from_data()
		get_viewport().set_input_as_handled()
		
	elif event.is_action_released("touch"):
		if _construction_blueprint.visible:
			_place_construction()
		
		else:
			_free_blueprint()
		get_viewport().set_input_as_handled()


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
	_move_construction_to_cell(_construction_blueprint, cell, target)
	
	trash_can.show()
	set_process(true)


func _move_construction_to_cell(construction: Construction, cell: Vector2i, 
		target: Vector2i) -> void:
	construction.position = target
	
	if not construction.evaluate_requirements(cell, passable_cells.get_occupants, 
			world.get_terrain_at_cells):
		construction.flag_as_invalid()
	
	else:
		construction.flag_as_valid()


func _place_construction() -> bool:
	var cell: = _grid.local_to_map(get_global_mouse_position())
	var target: = _grid.map_to_local(cell)
	var changed_cells: = _construction_blueprint.place(target, cell)
	
	trash_can.hide()
	if not _construction_blueprint.is_valid:
	#if passable_cells.get_occupants(changed_cells):
		_free_blueprint()
		return false
	passable_cells.set_cell_occupancy(changed_cells, true, _active_data)
	
	Events.construction_placed.emit(_construction_blueprint)
	_construction_blueprint = null
	
	return true


func _free_blueprint() -> void:
	
	print("Free blueprint")
	if _construction_blueprint:
		_construction_blueprint.queue_free()
	_construction_blueprint = null
	
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
