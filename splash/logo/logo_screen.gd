extends Control

@export var title: TitleScreen


func _ready() -> void:
	show()


func finish() -> void:
	Progression.logo_finished.emit()
	queue_free()


func play_music() -> void:
	title.play_music()
