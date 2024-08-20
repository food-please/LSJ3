class_name Dwellings extends RefCounted

const DWELLINGS: = {
	preload("res://constructions/dwellings/dwelling_data.tres"):0,
	preload("res://constructions/dwellings/dwelling_data2.tres"):0,
	preload("res://constructions/dwellings/dwelling_data3.tres"):0,
	
	# River dwellings
	preload("res://constructions/dwellings/river/river_dwelling1.tres"):0,
	preload("res://constructions/dwellings/river/river_dwelling2.tres"):0,
	preload("res://constructions/dwellings/river/river_dwelling3.tres"):0,
	
	# Forest dwellings
	preload("res://constructions/dwellings/forest/forest_dwelling1.tres"):0,
	preload("res://constructions/dwellings/forest/forest_dwelling2.tres"):0,
	preload("res://constructions/dwellings/forest/forest_dwelling3.tres"):0,
	
	# Town dwellings
	preload("res://constructions/dwellings/town/town_dwelling1.tres"):0,
}


static func get_random_dwelling() -> ConstructionData:
	var index: = randi() % DWELLINGS.size()
	return DWELLINGS.keys()[index]
