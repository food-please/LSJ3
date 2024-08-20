extends Construction

const TEXTURE_VARIATIONS: = [
	preload("res://constructions/dwellings/variations/dwelling_brown1.atlastex"),
	preload("res://constructions/dwellings/variations/dwelling_brown2.atlastex"),
	preload("res://constructions/dwellings/variations/dwelling_brown3.atlastex"),
	preload("res://constructions/dwellings/variations/dwelling_brown4.atlastex"),
	
	preload("res://constructions/dwellings/variations/dwelling_red1.atlastex"),
	preload("res://constructions/dwellings/variations/dwelling_red2.atlastex"),
	preload("res://constructions/dwellings/variations/dwelling_red3.atlastex"),
	preload("res://constructions/dwellings/variations/dwelling_red4.atlastex"),
	
	preload("res://constructions/dwellings/variations/dwelling_darkred1.atlastex"),
	preload("res://constructions/dwellings/variations/dwelling_darkred2.atlastex"),
	preload("res://constructions/dwellings/variations/dwelling_darkred3.atlastex"),
	preload("res://constructions/dwellings/variations/dwelling_darkred4.atlastex"),
	
	preload("res://constructions/dwellings/variations/dwelling_lightred1.atlastex"),
	preload("res://constructions/dwellings/variations/dwelling_lightred2.atlastex"),
	preload("res://constructions/dwellings/variations/dwelling_lightred3.atlastex"),
	preload("res://constructions/dwellings/variations/dwelling_lightred4.atlastex"),
]

@onready var _sprite: = $Sprite2D as Sprite2D


func _ready() -> void:
	var index: = randi() % TEXTURE_VARIATIONS.size()
	_sprite.texture = TEXTURE_VARIATIONS[index]
	
	super._ready()
