@tool
class_name ConstructionBubble extends Control

enum BubbleOrientation { TOP_LEFT, TOP_RIGHT, BOTTOM_LEFT, BOTTOM_RIGHT }

@export var orientation: BubbleOrientation:
	set(value):
		orientation = value
		if not is_inside_tree():
			await ready
		
		match orientation:
			BubbleOrientation.TOP_LEFT:
				tail.flip_h = false
				tail.flip_v = false
				tail.position = -tail.size
				
				bubble.position = Vector2(-bubble.size.x+1, -bubble.size.y-tail.size.y+1)
			BubbleOrientation.TOP_RIGHT:
				tail.flip_h = true
				tail.flip_v = false
				tail.position = Vector2(0, -tail.size.y)
				
				bubble.position = Vector2(-1, -bubble.size.y-tail.size.y+1)
			BubbleOrientation.BOTTOM_LEFT:
				tail.flip_h = false
				tail.flip_v = true
				tail.position = Vector2(-tail.size.x, 0)
				
				bubble.position = Vector2(-bubble.size.x+1, tail.size.y-1)
			BubbleOrientation.BOTTOM_RIGHT:
				tail.flip_h = true
				tail.flip_v = true
				tail.position = Vector2.ZERO
				
				bubble.position = Vector2(-1, tail.size.y-1)

@onready var bubble: = $Bubble
@onready var tail: = $Tail
