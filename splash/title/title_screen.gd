class_name TitleScreen extends ColorRect

var _listening_to_input: = false

@onready var _anim: = $AnimationPlayer as AnimationPlayer
@onready var _music: = $Music as AudioStreamPlayer
@onready var _sprite: = $AnimatedSprite2D as AnimatedSprite2D
@onready var _timer: = $WaitTimer as Timer


func _ready() -> void:
	show()
	Progression.logo_finished.connect(start)


func _input(event: InputEvent) -> void:
	get_viewport().set_input_as_handled()
	
	if _listening_to_input:
		if event.is_action_released("touch"):
			_listening_to_input = false
			
			_anim.play("blink_fast")
			
			_timer.start(1.0)
			await _timer.timeout
			
			_sprite.play(&"fade_out")
			await _sprite.animation_finished
			_sprite.hide()
			
			_anim.play("fade_out")
			await _anim.animation_finished
			
			queue_free()
			Progression.game_started.emit()


func start() -> void:
	_timer.start()
	await _timer.timeout
	
	_sprite.show()
	_sprite.play(&"fade_in")
	await _sprite.animation_finished
	
	_anim.play("blink")
	#_music.play()
	_listening_to_input = true


func play_music() -> void:
	_music.play()
