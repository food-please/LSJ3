class_name TrashCan extends TextureRect

@export var highlighted: Texture
@export var normal: Texture


func _ready() -> void:
	hide()
	texture = normal
	
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)


func _on_mouse_entered() -> void:
	texture = highlighted


func _on_mouse_exited() -> void:
	texture = normal
