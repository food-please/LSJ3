@tool
class_name UINumber extends CenterContainer

const DIGITS: = [
	preload("res://src/ui/number/number_0.atlastex"),
	preload("res://src/ui/number/number_1.atlastex"),
	preload("res://src/ui/number/number_2.atlastex"),
	preload("res://src/ui/number/number_3.atlastex"),
	preload("res://src/ui/number/number_4.atlastex"),
	preload("res://src/ui/number/number_5.atlastex"),
	preload("res://src/ui/number/number_6.atlastex"),
	preload("res://src/ui/number/number_7.atlastex"),
	preload("res://src/ui/number/number_8.atlastex"),
	preload("res://src/ui/number/number_9.atlastex"),
]

@export_range(0, 9999, 1, "greater_than") var quantity: int:
	set = set_quantity

@onready var _ones: = $Items/Ones as TextureRect
@onready var _tens: = $Items/Decs as TextureRect
@onready var _hundreds: = $Items/Cents as TextureRect
@onready var _thousands: = $Items/Mils as TextureRect


func set_quantity(value: int) -> void:
	quantity = value
	
	if not is_inside_tree():
		await ready
	
	_ones.texture = DIGITS[value % 10]
	
	if value > 9:
		@warning_ignore("integer_division")
		_tens.texture = DIGITS[(value/10)%10]
		_tens.show()
	else:
		_tens.hide()
	
	if value > 99:
		@warning_ignore("integer_division")
		_hundreds.texture = DIGITS[(value/100)%10]
		_hundreds.show()
	else:
		_hundreds.hide()
	
	if value > 999:
		@warning_ignore("integer_division")
		_thousands.texture = DIGITS[(value/1000)%10]
		_thousands.show()
	else:
		_thousands.hide()
