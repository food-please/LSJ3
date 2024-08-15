@tool
class_name UIRequirementType extends TextureRect

const TEXTURES: = {
	Modifier.Quantity: preload("res://src/ui/constructions/bubble/quantity.atlastex"),
	Modifier.GreaterThan: preload("res://src/ui/constructions/bubble/greater.atlastex"),
	Modifier.LessThan: preload("res://src/ui/constructions/bubble/less.atlastex"),
}

enum Modifier { Quantity, GreaterThan, LessThan }

@export var type: Modifier:
	set(value):
		type = value
		texture = TEXTURES.get(type, TEXTURES[Modifier.Quantity])
