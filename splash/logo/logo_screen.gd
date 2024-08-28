extends Control


func _ready() -> void:
	show()


func finish() -> void:
	Progression.logo_finished.emit()
	queue_free()
