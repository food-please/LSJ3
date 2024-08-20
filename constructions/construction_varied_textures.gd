class_name ConstructionVariation extends Construction

@export var variations: Array[Texture]

@onready var _sprite: = $Sprite2D as Sprite2D


func _ready() -> void:
	if not variations.is_empty():
		var index: = randi() % variations.size()
		_sprite.texture = variations[index]
	
	super._ready()
