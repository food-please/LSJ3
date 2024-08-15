extends Node2D

const CONSTRUCTION: = preload("res://constructions/construction.tscn")

const COLOR: = [ Color.WHITE, Color(1.0, 0.0, 0.0, 0.7), Color(0.0, 1.0, 0.0, 0.7)]

@export var grid: TileMapLayer

@export var trash_can: TrashCan

var _tileset: TileSet

var _active_data: ConstructionData = null
var _construction_blueprint: Construction = null


func _ready() -> void:
	assert(grid, "The building manager must have a TileMapLayer that defines the playable grid!")
	_tileset = grid.tile_set
	assert(_tileset, "The grid must have a tileset for buildings to be placed!")
	
	assert(trash_can, "The building manager neesd an available trash can!")
	#trash_can.gui_input.connect(_on_trash_can_gui_input)
	trash_can.mouse_entered.connect(_on_trash_can_mouse_entered)
	trash_can.mouse_exited.connect(_on_trash_can_mouse_exited)
	
	set_process_unhandled_input(false)
	Events.construction_data_selected.connect(
		func(data: ConstructionData):
			_active_data = data
			if _active_data:
				assert(_active_data.variations.size(), "Construction blueprint has no variations!")
			set_process_unhandled_input(data != null)
	)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenDrag and _construction_blueprint != null:
		_place_construction_at_cell(_construction_blueprint)
	
	elif event.is_action_pressed("touch"):
		_setup_new_blueprint_from_data()
		_place_construction_at_cell(_construction_blueprint)
		_construction_blueprint.modulate = COLOR[2]
		
		trash_can.show()
		
		get_viewport().set_input_as_handled()
		
	elif event.is_action_released("touch"):
		if _construction_blueprint.visible:
			_place_construction_at_cell(_construction_blueprint)
			_construction_blueprint.modulate = COLOR[0]
			
			Events.construction_placed.emit(_construction_blueprint)
			_construction_blueprint = null
			
			trash_can.hide()
		
		else:
			_construction_blueprint.queue_free()
			_construction_blueprint = null
			
			trash_can.hide()
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


func _place_construction_at_cell(construction: Construction) -> void:
	var cell: = grid.local_to_map(get_global_mouse_position())
	var target: = grid.map_to_local(cell)
	
	construction.position = target


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
