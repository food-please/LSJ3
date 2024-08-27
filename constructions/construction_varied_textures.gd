class_name ConstructionVariation extends Construction

@export var variations: Array[Texture]

var index: int

@onready var _sprite: = $Sprite2D as Sprite2D


func _ready() -> void:
	if not variations.is_empty():
		index = randi() % variations.size()
		_sprite.texture = variations[index]
	
	super._ready()


func increment_index() -> void:
	index += 1
	if index >= variations.size():
		index = 0
	_sprite.texture = variations[index]
