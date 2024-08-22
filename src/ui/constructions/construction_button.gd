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

#var _bubble: ConstructionBubble = null

@onready var _bubble_anchor: = $MarginContainer/Control/BubbleAnchor/Anchor as RemoteTransform2D
@onready var _button: = $MarginContainer/TextureButton as TextureButton
@onready var _icon: = $MarginContainer/Icon as TextureRect


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	Events.construction_data_selected.connect(
		func(data: ConstructionData, _anchor: RemoteTransform2D):
			if type == null or type != data:
				_button.set_pressed_no_signal(false)
	)
	Events.erase_selected.connect(func(_toggled: bool): _button.set_pressed_no_signal(false))
	
	_button.toggled.connect(
		func(value: bool):
			if value == true:
				Events.construction_data_selected.emit(type, _bubble_anchor)
			
			else:
				Events.construction_data_selected.emit(null, null)
	)
	pass
