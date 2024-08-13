@tool
extends CenterContainer

@export var type: ConstructionData:
	set(value):
		type = value
		
		if not is_inside_tree():
			await ready
		
		if type:
			_icon.texture = type.icon
		else:
			_icon.texture = null

@onready var _button: = $TextureButton as TextureButton
@onready var _icon: = $MarginContainer/Icon as TextureRect


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	$AnimationPlayer.play("default")
	
	Events.construction_data_selected.connect(
		func(data: ConstructionData):
			if type == null or type != data:
				_button.set_pressed_no_signal(false)
	)
	
	_button.toggled.connect(
		func(value: bool):
			if value == true:
				Events.construction_data_selected.emit(type)
			
			else:
				Events.construction_data_selected.emit(null)
	)
	pass
