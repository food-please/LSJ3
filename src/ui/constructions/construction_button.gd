@tool
extends CenterContainer

const BUBBLE: = preload("res://src/ui/constructions/bubble/construction_bubble.tscn")

@export var type: ConstructionData:
	set(value):
		type = value
		
		if not is_inside_tree():
			await ready
		
		if type:
			_icon.texture = type.icon
		else:
			_icon.texture = null

var _bubble: ConstructionBubble = null

@onready var _bubble_anchor: = $MarginContainer/Control/BubbleAnchor as Control
@onready var _button: = $MarginContainer/TextureButton as TextureButton
@onready var _icon: = $MarginContainer/Icon as TextureRect


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	Events.construction_data_selected.connect(
		func(data: ConstructionData):
			if type == null or type != data:
				if _bubble:
					_bubble.queue_free()
					_bubble = null
				_button.set_pressed_no_signal(false)
	)
	
	_button.toggled.connect(
		func(value: bool):
			if value == true:
				Events.construction_data_selected.emit(type)
				if _bubble:
					_bubble.queue_free()
					_bubble = null
				_bubble = BUBBLE.instantiate()
				_bubble.orientation = _bubble.BubbleOrientation.TOP_RIGHT
				_bubble_anchor.add_child(_bubble)
			
			else:
				Events.construction_data_selected.emit(null)
				if _bubble:
					_bubble.queue_free()
					_bubble = null
	)
	pass
