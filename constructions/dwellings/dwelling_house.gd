class_name ConstructionHouse extends ConstructionVariation


func face_direction(direction: String) -> void:
	match direction.to_lower():
		"up":
			pass
			@warning_ignore("integer_division")
			index = (index/4)*4 + 2
		"left":
			@warning_ignore("integer_division")
			index = (index/4)*4 + 1
		"right":
			@warning_ignore("integer_division")
			index = (index/4)*4 + 3
		_:
			@warning_ignore("integer_division")
			index = (index/4)*4
	_sprite.texture = variations[index]
