extends Control

const PLUS: = preload("res://src/ui/points/addition.atlastex")
const MINUS: = preload("res://src/ui/points/subtraction.atlastex")

@export var quantity: = 0:
	set(value):
		quantity = value
		
		if not is_inside_tree():
			await ready
		
		if quantity >= 0:
			_operator.texture = PLUS
			
			_number.modulate = Color.WHITE
			_operator.modulate = Color.WHITE
		
		else:
			_operator.texture = MINUS
			
			_number.modulate = Color.RED
			_operator.modulate = Color.RED
		
		_number.quantity = abs(quantity)

@onready var _operator: = $HBoxContainer/Operation as Control
@onready var _number: = $HBoxContainer/Number as UINumber
