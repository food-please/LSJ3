extends Node

@warning_ignore("unused_signal")
signal logo_finished

@warning_ignore("unused_signal")
signal game_started

signal first_house_placed

signal first_worker_placed

signal first_unique_placed

signal game_won

var cnsts_placed: = 0
var dwellings_placed: = 0
var uniques_placed: = 0

var has_won: = false

var are_uniques_in_citizen_bar: Callable


func _ready() -> void:
	Events.construction_placed.connect(_on_construction_placed)


func _on_construction_placed(construction: Construction) -> void:
	if construction is not ConstructionDwelling:
		cnsts_placed += 1
	
		if cnsts_placed == 1:
			first_house_placed.emit()
	
	# Dwelling placed
	else:
		dwellings_placed += 1
		
		if dwellings_placed == 1:
			first_worker_placed.emit()
		
		elif construction.value >= 1000:
			uniques_placed += 1
			if uniques_placed == 1:
				first_unique_placed.emit()
	
	await get_tree().process_frame
	if not has_won and Dwellings.uniques_remaining.is_empty() \
			and not are_uniques_in_citizen_bar.call():
		has_won = true
		game_won.emit()
		return
