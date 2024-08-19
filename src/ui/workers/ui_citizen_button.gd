@tool
class_name UIWorkerType extends CenterContainer

const BUBBLE: = preload("res://src/ui/constructions/bubble/construction_bubble.tscn")

const MOVE_TIME: = 0.3

const PORTRAITS: = {
	Constants.CITIZEN_COLOURS.Blue: preload("res://src/ui/workers/worker_portrait_blue.atlastex"),
	Constants.CITIZEN_COLOURS.Green: preload("res://src/ui/workers/worker_portrait_green.atlastex"),
	Constants.CITIZEN_COLOURS.Grey: preload("res://src/ui/workers/worker_portrait_grey.atlastex"),
	Constants.CITIZEN_COLOURS.Orange: \
		preload("res://src/ui/workers/worker_portrait_orange.atlastex"),
	Constants.CITIZEN_COLOURS.Red: preload("res://src/ui/workers/worker_portrait_red.atlastex"),
	Constants.CITIZEN_COLOURS.Yellow: \
		preload("res://src/ui/workers/worker_portrait_yellow.atlastex"),
}

signal citizen_settled
#signal citizen_left

@export var dwelling_data: ConstructionData

@export var portrait_colour: = Constants.CITIZEN_COLOURS.Blue:
	set(value):
		portrait_colour = value
		
		if not is_inside_tree():
			await ready
		
		portrait.texture = PORTRAITS.get(portrait_colour, null)

#var _bubble: ConstructionBubble = null

var _x_move_tween: Tween

@onready var bubble_anchor: = $MarginContainer/Control/BubbleAnchor/Anchor as RemoteTransform2D
@onready var button: = $MarginContainer/TextureButton as TextureButton
@onready var portrait: = $MarginContainer/Portrait as TextureRect


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	Events.construction_data_selected.connect(
		func(data: ConstructionData, _anchor: RemoteTransform2D):
			if dwelling_data == null or dwelling_data != data:
				if Events.construction_placed.is_connected(_on_construction_placed):
					Events.construction_placed.disconnect(_on_construction_placed)
				
				button.set_pressed_no_signal(false)
				#if _bubble:
					#_bubble.queue_free()
					#_bubble = null
	)
	
	button.toggled.connect(_on_button_toggled)


func move_in() -> void:
	if _x_move_tween:
		_x_move_tween.kill()
	_x_move_tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	
	_x_move_tween.tween_property(self, "position:x", 0, MOVE_TIME).from(16.0)


func move_out() -> void:
	if _x_move_tween:
		_x_move_tween.kill()
	_x_move_tween = create_tween().set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_BACK)
	
	_x_move_tween.tween_property(self, "position:x", 16.0, MOVE_TIME)
	_x_move_tween.tween_callback(queue_free)


func _on_button_toggled(value: bool) -> void:
	assert(dwelling_data, "A citizen '%s' has no dwelling data!" % name)
	if value == true:
		Events.construction_data_selected.emit(dwelling_data, bubble_anchor)
		#if _bubble:
			#_bubble.queue_free()
			#_bubble = null
		#_bubble = BUBBLE.instantiate()
		#_bubble.orientation = _bubble.BubbleOrientation.TOP_LEFT
		##bubble_anchor.add_child(_bubble)
		#
		#for requirement in dwelling_data.requirements:
			#var new_scene: = requirement.instantiate()
			#var new_requirement: = new_scene as UIConstructionRequirement
			#if not new_requirement:
				#new_scene.free()
			#
			#else:
				#_bubble.add_requirement(new_requirement)
		
		Events.construction_placed.connect(_on_construction_placed)
	
	else:
		if Events.construction_placed.is_connected(_on_construction_placed):
			Events.construction_placed.disconnect(_on_construction_placed)
			
		Events.construction_data_selected.emit(null, null)
		
		#if _bubble:
			#_bubble.queue_free()
			#_bubble = null

func _on_construction_placed(_construction: Construction) -> void:
	#if _bubble:
		#_bubble.queue_free()
		#_bubble = null
	
	button.disabled = true
	Events.construction_data_selected.emit(null, null)
	citizen_settled.emit()
