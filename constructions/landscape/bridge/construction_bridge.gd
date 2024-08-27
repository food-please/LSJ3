class_name ConstructionBridge extends ConstructionVariation


func face_direction(direction: String) -> void:
	match direction.to_lower():
		"h":
			index = 0
		_:
			index = 1
	_sprite.texture = variations[index]
