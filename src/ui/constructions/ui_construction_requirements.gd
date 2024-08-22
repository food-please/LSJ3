extends Control

const BUBBLE: = preload("res://src/ui/constructions/bubble/construction_bubble.tscn")

var _anchor: RemoteTransform2D = null
var _bubble: ConstructionBubble = null


func _ready() -> void:
	Events.construction_data_selected.connect(
		func(data: ConstructionData, anchor: RemoteTransform2D):
			_clear_bubble()
			if data and anchor :
				_bubble = BUBBLE.instantiate()
				add_child(_bubble)
				
				_anchor = anchor
				_set_bubble_position()
				
				for requirement in data.requirements:
					var new_scene: = requirement.instantiate()
					var new_requirement: = new_scene as UIConstructionRequirement
					if not new_requirement:
						new_scene.free()
					else:
						_bubble.add_requirement(new_requirement)
				
			set_process(data and anchor)
	)
	
	Events.erase_selected.connect(
		func(_toggled: bool):
			_clear_bubble()
	)
	
	set_process(false)


func _process(_delta: float) -> void:
	_set_bubble_position()


func _set_bubble_position() -> void:
	_bubble.global_position = _anchor.global_position
	
	if _bubble.global_position.y < 20:
		if _bubble.global_position.x < 128:
			_bubble.orientation = _bubble.BubbleOrientation.BOTTOM_RIGHT
			
		else:
			_bubble.orientation = _bubble.BubbleOrientation.BOTTOM_LEFT
	
	else:
		if _bubble.global_position.x < 128:
			_bubble.orientation = _bubble.BubbleOrientation.TOP_RIGHT
		
		else:
			_bubble.orientation = _bubble.BubbleOrientation.TOP_LEFT


func _clear_bubble() -> void:
	if _anchor:
		_anchor.remote_path = ""
		_anchor = null
	
	if _bubble:
		_bubble.queue_free()
		_bubble = null
	
	set_process(false)
