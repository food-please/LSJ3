extends Control

const FLOATING_PTS: = preload("res://src/ui/points/floating_point.tscn")

@export var delta_duration: = 0.4

var _tween: Tween

@onready var _number: = $Counter/CenterContainer/HBoxContainer/Number as UINumber

func _ready() -> void:
	_number.quantity = Economy.points
	
	Economy.points_changed.connect(_on_points_changed)
	
	Events.construction_placed.connect(_on_construction_placed)


func _on_points_changed() -> void:
	if _tween:
		_tween.kill()
	_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_QUAD)
	_tween.tween_property(_number, "quantity", Economy.points, delta_duration)


func _on_construction_placed(construction: Construction) -> void:
	var new_floating_points: = FLOATING_PTS.instantiate()
	add_child(new_floating_points)
	
	if construction is ConstructionDwelling:
		new_floating_points.quantity = construction.value
	
	elif construction is TerrainConstruction:
		new_floating_points.quantity = -construction.value * construction.get_cells().size()
	
	else:
		new_floating_points.quantity = -construction.value
		
	var cam_pos: Vector2 = construction.get_viewport().get_camera_2d().get_parent().global_position
	new_floating_points.global_position = construction.global_position - Vector2(0, 4)	\
		- cam_pos + Vector2(128, 72)
