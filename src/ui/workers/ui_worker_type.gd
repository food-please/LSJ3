@tool
class_name UIWorkerType extends CenterContainer

const PORTRAITS: = {
	"Blue": preload("res://src/ui/workers/worker_portrait_blue.atlastex"),
	"Green": preload("res://src/ui/workers/worker_portrait_green.atlastex"),
	"Grey": preload("res://src/ui/workers/worker_portrait_grey.atlastex"),
	"Orange": preload("res://src/ui/workers/worker_portrait_orange.atlastex"),
	"Red": preload("res://src/ui/workers/worker_portrait_red.atlastex"),
	"Yellow": preload("res://src/ui/workers/worker_portrait_yellow.atlastex"),
}

@export_enum("Blue", "Green", "Grey", "Orange", "Red", "Yellow") var portrait_colour: = "Blue":
	set(value):
		portrait_colour = value
		
		if not is_inside_tree():
			await ready
		
		portrait.texture = PORTRAITS.get(portrait_colour, null)


@onready var portrait: = $Portrait as TextureRect
