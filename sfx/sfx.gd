extends AudioStreamPlayer

const SFX: = {
	"click": preload("res://sfx/sfx_click.ogg"),
	"erase": preload("res://sfx/sfx_delete.ogg"),
	"invalid": preload("res://sfx/sfx_invalid.ogg"),
	"place": preload("res://sfx/sfx_plunk.ogg"),
	"place_dwelling": preload("res://sfx/sfx_select.ogg"),
}

func _ready() -> void:
	Events.cell_erased.connect(
		func(_cell: Vector2i):
			stream = SFX.get("erase")
			play()
	)
	
	Events.erase_selected.connect(
		func(_toggled: bool):
			stream = SFX.get("click")
			play()
	)
	
	Events.construction_data_selected.connect(
		func(data: ConstructionData, _anchor: RemoteTransform2D):
			if data:
				stream = SFX.get("click")
				play()
	)
	
	Events.construction_placed.connect(
		func(construction: Construction):
			stream = SFX.get("place")
			if construction is ConstructionDwelling:
				stream = SFX.get("place_dwelling")
			play()
	)
	
	Events.invalid_construction_placed.connect(
		func():
			stream = SFX.get("invalid")
			play()
	)

pass
