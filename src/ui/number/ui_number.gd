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

const WHITE_DIGITS: = [
	preload("res://src/ui/number/number_0_white.atlastex"),
	preload("res://src/ui/number/number_1_white.atlastex"),
	preload("res://src/ui/number/number_2_white.atlastex"),
	preload("res://src/ui/number/number_3_white.atlastex"),
	preload("res://src/ui/number/number_4_white.atlastex"),
	preload("res://src/ui/number/number_5_white.atlastex"),
	preload("res://src/ui/number/number_6_white.atlastex"),
	preload("res://src/ui/number/number_7_white.atlastex"),
	preload("res://src/ui/number/number_8_white.atlastex"),
	preload("res://src/ui/number/number_9_white.atlastex"),
]

@export_enum("black", "white") var type: = "black":
	set(value):
		type = value
		set_quantity(quantity)

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
	
	var texture_source: = DIGITS
	if type == "white":
		texture_source = WHITE_DIGITS
	
	_ones.texture = texture_source[value % 10]
	
	if value > 9:
		@warning_ignore("integer_division")
		_tens.texture = texture_source[(value/10)%10]
		_tens.show()
	else:
		_tens.hide()
	
	if value > 99:
		@warning_ignore("integer_division")
		_hundreds.texture = texture_source[(value/100)%10]
		_hundreds.show()
	else:
		_hundreds.hide()
	
	if value > 999:
		@warning_ignore("integer_division")
		_thousands.texture = texture_source[(value/1000)%10]
		_thousands.show()
	else:
		_thousands.hide()
