class_name UIConstructionRequirement extends MarginContainer

@export var data: ConstructionRequirement:
	set(value):
		data = value
		
		if not is_inside_tree():
			await ready

@onready var icon: = $HBoxContainer/Icon as TextureRect
@onready var modifier: = $HBoxContainer/Modifier as UIRequirementType
@onready var number: = $HBoxContainer/Number as UINumber
