extends ColorRect

signal finished

var _listening_to_input: = false

@onready var _anim: = $AnimationPlayer as AnimationPlayer
@onready var _score: = $MarginContainer/CenterContainer/VBoxContainer/Score
@onready var _cnsts: = $MarginContainer/CenterContainer/VBoxContainer/Constructions
@onready var _dwell: = $MarginContainer/CenterContainer/VBoxContainer/Dwellings


func _ready() -> void:
	_anim.play("appear")
	
	_score.text = "Score: %d" % Economy._score
	_cnsts.text = "Constructions: %d" % Progression.cnsts_placed
	_dwell.text = "Citizens: %d" % Progression.dwellings_placed
	
	await _anim.animation_finished
	_listening_to_input = true


func _input(event: InputEvent) -> void:
	get_viewport().set_input_as_handled()
	
	if _listening_to_input:
		if event.is_action_released("touch"):
			_listening_to_input = false
			_anim.play("disappear")


func finish() -> void:
	finished.emit()
	queue_free()
