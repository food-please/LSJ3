extends CenterContainer

const CITIZEN: = preload("res://src/ui/workers/citizen_button.tscn")

@export var max_concurrent_citizens: = 7

var _y_move_tween: Tween

@onready var _citizens: = $VBoxContainer as Control
@onready var _disposal: = $OldWorkers as Control


func _ready() -> void:
	$Timer.start()
	$Timer.timeout.connect(
		func():
			#print(Dwellings.DWELLINGS.size(), " Timeout ", Dwellings.DWELLINGS.size() > _citizens.get_child_count(), 
				#" ", _citizens.get_child_count() <= 7)
			add_random_citizen()
	)


func add_random_citizen() -> void:
	if Dwellings.DWELLINGS.size() > _citizens.get_child_count() \
			and _citizens.get_child_count() < max_concurrent_citizens:
		var new_data: ConstructionData = null
		while(true):
			new_data = Dwellings.get_random_dwelling()
			if _citizen_has_data(new_data):
				continue
			
			break
		
		add_citizen(Constants.get_random_citizen_colour(), new_data)


func add_citizen(colour: Constants.CITIZEN_COLOURS, dwelling_data: ConstructionData) -> String:
	var new_citizen = CITIZEN.instantiate()
	new_citizen.portrait_colour = colour
	new_citizen.dwelling_data = dwelling_data
	
	_citizens.add_child(new_citizen)
	_move_citizens_to_new_positions([new_citizen])
	new_citizen.move_in()
	
	new_citizen.citizen_settled.connect(remove_citizen.bind(new_citizen.name))
	return new_citizen.name


func remove_citizen(uid: String) -> void:
	if _citizens.has_node(uid):
		var citizen: = _citizens.get_node(uid) as UIWorkerType
		if citizen:
			var old_position: = citizen.global_position
			
			_citizens.remove_child(citizen)
			_disposal.add_child(citizen)
			citizen.global_position = old_position
			
			citizen.move_out()
			_move_citizens_to_new_positions()


#func _unhandled_input(event: InputEvent) -> void:
	#if event.is_action_released("touch"):
		#add_citizen(Constants.CITIZEN_COLOURS.Green)
	#
	#elif event.is_action_released("ui_accept"):
		#remove_citizen(_citizens.get_child(1).name)


func _move_citizens_to_new_positions(static_controls: Array[Control] = []) -> void:
	var moved_citizens: Array[Node] = []
	for child in _citizens.get_children():
		if child is UIWorkerType and not child in static_controls:
			moved_citizens.append(child)
	
	if moved_citizens.size() == 0:
		return
	
	var old_positions: = {}
	for child: Control in moved_citizens:
		old_positions[child] = child.global_position.y
		
	await  get_tree().process_frame
	
	if _y_move_tween:
		_y_move_tween.kill()
	_y_move_tween = create_tween().set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_LINEAR)
	
	for citizen: Control in moved_citizens:
		_y_move_tween.parallel().tween_property(citizen, "global_position:y", 
			citizen.global_position.y, 0.2).from(old_positions[citizen])


func _citizen_has_data(data: ConstructionData) -> bool:
	for child: UIWorkerType in _citizens.get_children():
		if child.dwelling_data == data:
			return true
	return false
