class_name Dwellings extends RefCounted

const DWELLINGS: = {
	# Generic dwellings
	#preload("res://constructions/dwellings/dwelling_data.tres"):0,
	preload("res://constructions/dwellings/dwelling_data2.tres"):0,
	preload("res://constructions/dwellings/dwelling_data3.tres"):0,
	
	# Farm dwellings
	preload("res://constructions/dwellings/farm/farm_dwelling1.tres"):0,
	preload("res://constructions/dwellings/farm/farm_dwelling2.tres"):0,
	preload("res://constructions/dwellings/farm/mill_dwelling.tres"):0,
	
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

const UNIQUE_DWELLINGS: = {
	"beeatrice": \
		preload("res://constructions/dwellings/unique/beeatrice/beeatrice_dwelling_data.tres"),
	
	"benny": preload("res://constructions/dwellings/unique/benny/benny_dwelling_data.tres"),
	
	"castandra": preload("res://constructions/dwellings/unique/castandra/cast_dwelling_data.tres"),
	
	"garganoth": preload("res://constructions/dwellings/unique/garganoth/garg_dwelling_data.tres"),
	
	"skeagles": preload("res://constructions/dwellings/unique/skeagles/skeagles_dwelling_data.tres"),
	
	"wolflor": preload("res://constructions/dwellings/unique/wolflor/wolflor_dwelling_data.tres"),
}

static var uniques_remaining: = [
	"beeatrice",
	"benny",
	"castandra",
	"garganoth",
	"skeagles",
	"wolflor"
]


static func get_random_dwelling() -> ConstructionData:
	var index: = randi() % DWELLINGS.size()
	return DWELLINGS.keys()[index].duplicate()


static func get_unique_dwelling() -> ConstructionData:
	if uniques_remaining.is_empty():
		return null
	
	var index: = randi() % uniques_remaining.size()
	var key = uniques_remaining.pop_at(index)
	return UNIQUE_DWELLINGS.get(key, null)
