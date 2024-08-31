@tool
extends MarginContainer

const BUTTON: = preload("res://src/ui/constructions/button/construction_button.tscn")

@export var category: ConstructionsCategory:
	set(value):
		category = value
		
		if not is_inside_tree():
			await ready
		
		for element in _buttons.get_children():
			element.queue_free()
		
		if category:
			var num_items: = category.constructions.size()
			if num_items < 5:
				_scroll.custom_minimum_size.y = 18*num_items + 6
			else:
				_scroll.custom_minimum_size.y = 96
			
			for data: ConstructionData in category.constructions:
				var new_button = BUTTON.instantiate()
				_buttons.add_child(new_button)
				
				new_button.type = data


@onready var _buttons: = $MarginContainer/ScrollContainer/VBoxContainer as VBoxContainer
@onready var _scroll: = $MarginContainer/ScrollContainer as ScrollContainer
