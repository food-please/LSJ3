class_name CloudCover extends TileMapLayer

signal cover_changed()

@export var terrain: TileMapLayer

var _explored_cells: Array[Vector2i] = []

@onready var _anim: = $AnimationPlayer as AnimationPlayer
@onready var _overlay: = $Overlay as TileMapLayer


func _ready() -> void:
	show()
	_overlay.hide()
	_overlay.tile_set = tile_set
	
	# Default to covering the world.
	var used_cells: Array[Vector2i] = []
	var used_rect: = terrain.get_used_rect().grow(1)
	for x in range(used_rect.size.x+1):
		for y in range(used_rect.size.y + 1):
			used_cells.append(Vector2i(x-1, y-1))
	set_cells_terrain_connect(used_cells, 0, 0)
	
	_anim.animation_finished.connect(
		func(_name: String): cover_changed.emit()
	)
	
	Events.construction_placed.connect(_on_construction_placed)


func reveal_cells(cells: Array[Vector2i]) -> void:
	if not _anim.is_playing():
		_overlay.clear()
		_overlay.set_cells_terrain_connect(get_used_cells(), 0, 0)
		
		set_cells_terrain_connect(cells, 0, -1)
		#for cell in cells:
			#erase_cell(cell)
		_overlay.show()
		_overlay.modulate = Color.WHITE
		_anim.play("reveal")
		
		_explored_cells.append_array(cells)


func are_cells_clear(cells: Array[Vector2i]) -> bool:
	var used_cells: = get_used_cells()
	for cell in cells:
		var cloud_cell: = cell/2
		if cloud_cell in used_cells:
			return false
	return true


func get_revealed_camera_extents() -> Rect2i:
	if _explored_cells.is_empty():
		return Rect2i()
	
	var bounds: = Rect2i(_explored_cells[0], Vector2i(1, 1))
	for cell in _explored_cells:
		bounds = bounds.expand(cell)
	#bounds.size += Vector2i.ONE
	
	# Convert to from cells to pixels
	bounds.position = bounds.position * tile_set.tile_size
	bounds.size = bounds.size * tile_set.tile_size
	return bounds


func _on_construction_placed(construction: Construction) -> void:
	var origin: = construction.cell / 2
	
	var lower_bound: = origin - Vector2i(construction.vision, construction.vision)
	var upper_bound: = origin + Vector2i(construction.vision, construction.vision)
	
	var revealed_cells: Array[Vector2i] = []
	for x in range(lower_bound.x, upper_bound.x+1):
		for y in range(lower_bound.y, upper_bound.y+1):
			var distance: float = abs(origin.x - x) + abs(origin.y - y)
			if distance <= construction.vision:
				var cell: = Vector2i(x, y)
				if cell in get_used_cells():
					revealed_cells.append(cell)
	
	reveal_cells(revealed_cells)
