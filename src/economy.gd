extends Node

signal points_changed

var points: = 1000:
	set(value):
		if value != points:
			points = value
			points_changed.emit()

var _score = 0


func add_score(value: int) -> void:
	_score += value
