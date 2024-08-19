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
				#if _bubble:
					#_bubble.queue_free()
					#_bubble = null
				_button.set_pressed_no_signal(false)
	)
	
	_button.toggled.connect(
		func(value: bool):
			print("Toggled!")
			if value == true:
				Events.construction_data_selected.emit(type, _bubble_anchor)
				#if _bubble:
					#_bubble.queue_free()
					#_bubble = null
				#_bubble = BUBBLE.instantiate()
				#_bubble.orientation = _bubble.BubbleOrientation.TOP_RIGHT
				##_bubble_anchor.add_child(_bubble)
				#add_child(_bubble)
				#move_child(_bubble, 0)
				#_bubble_anchor.remote_path = _bubble_anchor.get_path_to(_bubble)
				
				#for requirement in type.requirements:
					#var new_scene: = requirement.instantiate()
					#var new_requirement: = new_scene as UIConstructionRequirement
					#if not new_requirement:
						#new_scene.free()
					#
					#else:
						#_bubble.add_requirement(new_requirement)
			
			else:
				Events.construction_data_selected.emit(null, null)
				#if _bubble:
					#_bubble.queue_free()
					#_bubble = null
	)
	pass
