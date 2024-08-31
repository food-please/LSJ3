extends TextureButton


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	toggled.connect(
		func(is_toggled: bool):
			Events.erase_selected.emit(is_toggled)
	)
	
	Events.construction_data_selected.connect(
		func(_data: ConstructionData, _anchor: RemoteTransform2D):
			set_pressed_no_signal(false)
	)
	pass
