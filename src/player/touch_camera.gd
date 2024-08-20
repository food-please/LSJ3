class_name TouchCamera extends Node2D

# How far the cursor must drag before the event is recognized as a drag (vs a
#	touch).
@export var DRAG_THRESHOLD: = 10.0
@export var CLICK_THRESHOLD: = 20.0

# Keep track of the distance dragged before allowing the touch event through.
var _drag_distance: = 0.0
var _is_dragged: = false

@export var boundary: = Rect2():
	set(value):
		boundary = value
		clamp_to_boundary()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventScreenDrag and _is_dragged:
		_drag_distance += event.relative.length()
		if _drag_distance >= DRAG_THRESHOLD:
			position -= event.relative
			clamp_to_boundary()
		
		get_viewport().set_input_as_handled()
	
	if event.is_action_pressed("touch"):
		_is_dragged = true
		_drag_distance = 0.0
	
	elif event.is_action_released("touch"):
		_is_dragged = false
		
		# If the cursor has been dragged far enough, act like it was meant for the camera and do 
		# not allow other objects to act on it.
		if _drag_distance >= CLICK_THRESHOLD:
			get_viewport().set_input_as_handled()


func scroll(offset: Vector2) -> void:
	position += offset
	clamp_to_boundary()


func clamp_to_boundary() -> void:
	if not boundary.has_point(global_position):
		global_position.x = clampf(global_position.x, boundary.position.x, boundary.end.x)
		global_position.y = clampf(global_position.y, boundary.position.y, boundary.end.y)
