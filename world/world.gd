extends Node2D

@onready var terrain: = $Terrain as TileMapLayer

func _ready() -> void:
	print(terrain)

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("touch"):
		var cell: = terrain.local_to_map(get_global_mouse_position())
		
		#var new_construction: = preload("res://constructions/dwellings/dwelling.tscn").instantiate()
		#$Buildings.add_child(new_construction)
		#new_construction.position = terrain.map_to_local(cell)
