class_name Constants extends RefCounted

enum CITIZEN_COLOURS { Blue, Green, Grey, Orange, Red, Yellow }


static func get_random_citizen_colour() -> CITIZEN_COLOURS:
	var index: = randi() % CITIZEN_COLOURS.size()
	var colour_id: String = CITIZEN_COLOURS.keys()[index]
	return CITIZEN_COLOURS[colour_id]
